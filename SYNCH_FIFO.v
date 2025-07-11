`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2025
// Design Name: 
// Module Name: SYNCH_FIFO
// Project Name: Parameterizable FIFO
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module qs_fifo #(
  parameter DATA_W = 8,
  parameter DEPTH = 4
)(
  input clk,
  input reset,
  input push_i,
  input [DATA_W-1:0] push_data_i,
  input pop_i,
  output [DATA_W-1:0] pop_data_o,
  output full_o,
  output empty_o
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

  // State encoding for push/pop
  localparam ST_PUSH = 2'b10;
  localparam ST_POP  = 2'b01;
  localparam ST_BOTH = 2'b11;

  // FIFO storage
  reg [DATA_W-1:0] fifo_data_q [0:DEPTH-1];
  reg [PTR_W-1:0] rd_ptr_q, wr_ptr_q;
  reg [PTR_W-1:0] nxt_rd_ptr, nxt_wr_ptr;
  reg wrapped_rd_ptr_q, wrapped_wr_ptr_q;
  reg nxt_rd_wrapped_ptr, nxt_wr_wrapped_ptr;
  reg [DATA_W-1:0] nxt_fifo_data;
  reg [DATA_W-1:0] pop_data;
  reg empty, full;

  // Pointer and wrap logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      rd_ptr_q <= {PTR_W{1'b0}};
      wr_ptr_q <= {PTR_W{1'b0}};
      wrapped_rd_ptr_q <= 1'b0;
      wrapped_wr_ptr_q <= 1'b0;
    end else begin
      rd_ptr_q <= nxt_rd_ptr;
      wr_ptr_q <= nxt_wr_ptr;
      wrapped_rd_ptr_q <= nxt_rd_wrapped_ptr;
      wrapped_wr_ptr_q <= nxt_wr_wrapped_ptr;
    end
  end

  // Next-state logic
  always @(*) begin
    nxt_fifo_data = fifo_data_q[wr_ptr_q];
    nxt_rd_ptr = rd_ptr_q;
    nxt_wr_ptr = wr_ptr_q;
    nxt_wr_wrapped_ptr = wrapped_wr_ptr_q;
    nxt_rd_wrapped_ptr = wrapped_rd_ptr_q;
    case ({push_i, pop_i})
      ST_PUSH: begin
        nxt_fifo_data = push_data_i;
        if (wr_ptr_q == (DEPTH-1)) begin
          nxt_wr_ptr = {PTR_W{1'b0}};
          nxt_wr_wrapped_ptr = ~wrapped_wr_ptr_q;
        end else begin
          nxt_wr_ptr = wr_ptr_q + 1'b1;
        end
      end
      ST_POP: begin
        pop_data = fifo_data_q[rd_ptr_q];
        if (rd_ptr_q == (DEPTH-1)) begin
          nxt_rd_ptr = {PTR_W{1'b0}};
          nxt_rd_wrapped_ptr = ~wrapped_rd_ptr_q;
        end else begin
          nxt_rd_ptr = rd_ptr_q + 1'b1;
        end
      end
      ST_BOTH: begin
        nxt_fifo_data = push_data_i;
        if (wr_ptr_q == (DEPTH-1)) begin
          nxt_wr_ptr = {PTR_W{1'b0}};
          nxt_wr_wrapped_ptr = ~wrapped_wr_ptr_q;
        end else begin
          nxt_wr_ptr = wr_ptr_q + 1'b1;
        end
        pop_data = fifo_data_q[rd_ptr_q];
        if (rd_ptr_q == (DEPTH-1)) begin
          nxt_rd_ptr = {PTR_W{1'b0}};
          nxt_rd_wrapped_ptr = ~wrapped_rd_ptr_q;
        end else begin
          nxt_rd_ptr = rd_ptr_q + 1'b1;
        end
      end
      default: begin
        nxt_fifo_data = fifo_data_q[wr_ptr_q];
        nxt_rd_ptr = rd_ptr_q;
        nxt_wr_ptr = wr_ptr_q;
      end
    endcase
  end

  // Empty and full logic
  always @(*) begin
    empty = (rd_ptr_q == wr_ptr_q) && (wrapped_rd_ptr_q == wrapped_wr_ptr_q);
    full  = (rd_ptr_q == wr_ptr_q) && (wrapped_rd_ptr_q != wrapped_wr_ptr_q);
  end

  // FIFO data update
  always @(posedge clk) begin
    fifo_data_q[wr_ptr_q] <= nxt_fifo_data;
  end

  // Output assignments
  assign pop_data_o = pop_data;
  assign full_o = full;
  assign empty_o = empty;

endmodule
