`timescale 1ns/1ps
interface fifo_int #(parameter ADDR_WIDTH =5,  DATA_WIDTH = 8, fifo_size =2**ADDR_WIDTH) (
	input clk, [ADDR_WIDTH-1:0] write_ptr, read_ptr,
	[DATA_WIDTH-1:0] fifo  [fifo_size-1:0]
	);
	logic reset, Wr_enable, Read_enable;
	logic full, empty;
	logic [DATA_WIDTH-1:0] data_in;
	logic [DATA_WIDTH-1:0] data_out;

	clocking cb @(posedge clk);
		default input #1step output #3; 
		inout reset, Wr_enable, Read_enable, data_in, write_ptr, read_ptr, fifo;
		input data_out;
	endclocking

	modport TB  (clocking cb, input full, empty, write_ptr, read_ptr);
	modport DUT (input  clk, reset, Wr_enable, Read_enable, data_in, output full, empty, data_out); // Useless while keeping the FIFO RTL untouched
endinterface : fifo_int