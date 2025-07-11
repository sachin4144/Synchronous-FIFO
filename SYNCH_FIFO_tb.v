`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2025 19:33:34
// Design Name: 
// Module Name: SYNCH_FIFO_tb
// Project Name: 
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


module qs_fifo_tb;

  // Parameters
  parameter DATA_W = 8;
  parameter DEPTH  = 2;

  // DUT signals
  reg clk;
  reg reset;
  reg push_i;
  reg [DATA_W-1:0] push_data_i;
  reg pop_i;
  wire [DATA_W-1:0] pop_data_o;
  wire full_o;
  wire empty_o;

  // Instantiate the FIFO (explicit port mapping for Verilog)
  qs_fifo #(.DATA_W(DATA_W), .DEPTH(DEPTH)) FIFO (
    .clk(clk),
    .reset(reset),
    .push_i(push_i),
    .push_data_i(push_data_i),
    .pop_i(pop_i),
    .pop_data_o(pop_data_o),
    .full_o(full_o),
    .empty_o(empty_o)
  );

  // Clock generation: 10ns period
  initial clk = 0;
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    reset = 1'b1;
    push_i = 1'b0;
    pop_i = 1'b0;
    push_data_i = 8'h00;
    // Hold reset for two cycles
    repeat (2) @(posedge clk);
    reset = 1'b0;

    // Push 8'hAB
    @(posedge clk);
    push_i = 1'b1;
    push_data_i = 8'hAB;

    // Push 8'hCC
    @(posedge clk);
    push_data_i = 8'hCC;

    // Stop pushing
    @(posedge clk);
    push_i = 1'b0;
    push_data_i = 8'hxx;

    // Pop one value
    @(posedge clk);
    pop_i = 1'b1;

    // Stop popping
    @(posedge clk);
    pop_i = 1'b0;

    // Wait two more cycles
    repeat (2) @(posedge clk);

    $finish;
  end

  // Dump VCD waveform
  initial begin
    $dumpfile("qs_fifo.vcd");
    $dumpvars(2, qs_fifo_tb);
  end

endmodule