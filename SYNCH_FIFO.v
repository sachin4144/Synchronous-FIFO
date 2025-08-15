`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 10.07.2025
// Design Name: 
// Module Name: qs_fifo
// Project Name: Parameterizable FIFO
// Target Devices: 
// Tool Versions: 
// Description: Parameterizable synchronous FIFO with robust full/empty logic
//////////////////////////////////////////////////////////////////////////////////

module qs_fifo #(
    parameter DATA_W = 8,
    parameter DEPTH  = 4
)(
    input                        clk,
    input                        reset,
    input                        push_i,
    input      [DATA_W-1:0]      push_data_i,
    input                        pop_i,
    output reg [DATA_W-1:0]      pop_data_o,
    output reg                   full_o,
    output reg                   empty_o
);

    // Calculate pointer width
    function integer clog2;
        input integer value;
        integer i;
        begin
            clog2 = 0;
            for (i = value - 1; i > 0; i = i >> 1)
                clog2 = clog2 + 1;
        end
    endfunction

    localparam PTR_W = clog2(DEPTH);

    // FIFO storage
    reg [DATA_W-1:0] fifo_mem [0:DEPTH-1];
    reg [PTR_W-1:0]  rd_ptr, wr_ptr;
    reg              rd_wrap, wr_wrap;

    // Internal status signals
    wire full_cond = (rd_ptr == wr_ptr) && (rd_wrap != wr_wrap);
    wire empty_cond = (rd_ptr == wr_ptr) && (rd_wrap == wr_wrap);

    // Output status
    always @(*) begin
        full_o  = full_cond;
        empty_o = empty_cond;
    end

    // Data output
    always @(*) begin
        if (pop_i && !empty_o)
            pop_data_o = fifo_mem[rd_ptr];
        else
            pop_data_o = {DATA_W{1'b0}};
    end

    // FIFO read/write logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rd_ptr  <= 0;
            wr_ptr  <= 0;
            rd_wrap <= 0;
            wr_wrap <= 0;
        end else begin
            // Write logic
            if (push_i && !full_o) begin
                fifo_mem[wr_ptr] <= push_data_i;
                if (wr_ptr == (DEPTH-1)) begin
                    wr_ptr  <= 0;
                    wr_wrap <= ~wr_wrap;
                end else begin
                    wr_ptr <= wr_ptr + 1;
                end
            end

            // Read logic
            if (pop_i && !empty_o) begin
                if (rd_ptr == (DEPTH-1)) begin
                    rd_ptr  <= 0;
                    rd_wrap <= ~rd_wrap;
                end else begin
                    rd_ptr <= rd_ptr + 1;
                end
            end
        end
    end

endmodule
