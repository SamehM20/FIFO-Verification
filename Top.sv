`timescale 1ns/1ps
module Top;
    // Creating the System Clock
    bit clk;
    always #20 clk = ~clk;

    fifo_int #(.DATA_WIDTH(32))fi_int (clk, dut.write_ptr, dut.read_ptr, dut.FIFO);

    // It is required to keep the Design RTL untouched.
    FIFO #(.ADDR_WIDTH(fi_int.ADDR_WIDTH) ,  .DATA_WIDTH(fi_int.DATA_WIDTH)) dut 
         (fi_int.clk, fi_int.reset, fi_int.Wr_enable, fi_int.data_in,
          fi_int.Read_enable, fi_int.full, fi_int.empty, fi_int.data_out);
    
    TB tb (fi_int);
endmodule