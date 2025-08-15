`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date: 10.07.2025
// Design Name: 
// Module Name: qs_fifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for qs_fifo
//////////////////////////////////////////////////////////////////////////////////

module qs_fifo_tb;

    // Parameters for FIFO
    parameter DATA_W = 8;
    parameter DEPTH  = 2;

    // DUT (Device Under Test) signals
    reg                  clk;
    reg                  reset;
    reg                  push_i;
    reg   [DATA_W-1:0]   push_data_i;
    reg                  pop_i;
    wire  [DATA_W-1:0]   pop_data_o;
    wire                 full_o;
    wire                 empty_o;

    // Instantiating FIFO, named FIFO
    qs_fifo #(.DATA_W(DATA_W), .DEPTH(DEPTH)) FIFO (
        .clk           (clk),
        .reset         (reset),
        .push_i        (push_i),
        .push_data_i   (push_data_i),
        .pop_i         (pop_i),
        .pop_data_o    (pop_data_o),
        .full_o        (full_o),
        .empty_o       (empty_o)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    
    initial begin
        // Initialize inputs
        reset         = 1'b1;
        push_i        = 1'b0;
        pop_i         = 1'b0;
        push_data_i   = 8'h00;

        
        #12;
        reset = 1'b0;

        // Pushing first data
        @(posedge clk);
        push_i      = 1'b1;
        push_data_i = 8'hAB;

        // Pushing second data
        @(posedge clk);
        push_data_i = 8'hCC;

        
        @(posedge clk);
        push_i      = 1'b0;
        push_data_i = 8'h00;

        // Popping one data
        @(posedge clk);
        pop_i = 1'b1;

        // Stop popping
        @(posedge clk);
        pop_i = 1'b0;

        
        repeat (2) @(posedge clk);

        
        $finish;
    end

    
    initial begin
        $dumpfile("qs_fifo_tb.vcd");
        $dumpvars(0, qs_fifo_tb);
    end

endmodule
