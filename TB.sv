import randpack::ranData; // Importing the Random Class
module TB (fifo_int intf);
  ranData randata;
  /*
  always @intf.cb $display("At time: %t, Reset = %d, Data Input = %d, Write Enable = %d, Read Enable = %d, Data Output = %d, Full Flag = %d, Empty Flag = %d",
                           $time(), intf.cb.reset, intf.cb.data_in, intf.cb.Wr_enable, intf.cb.Read_enable, intf.cb.data_out, intf.full, intf.empty);
  */

    // Creating Cover points for the Empty and Full Flags
    covergroup flag_cg @intf.cb;
      cp_empty: coverpoint intf.empty iff(!intf.cb.reset) {
        bins Empty = {1};
        bins NotEmpty = {0};
        bins ChangingFromEmpty = (1=>0);
        bins GettingEmpty = (0=>1);
      }
      cp_full: coverpoint intf.full iff(!intf.cb.reset) {
        bins Full = {1};
        bins NotFull = {0};
        bins ChangingFromFull = (1=>0);
        bins GettingFull = (0=>1);
      }
    endgroup

    // Assertions:
    // When the Write_enable signal is asserted and the FIFO is not full, the write pointer should increment.
    wr_ptr_inc: assert property (@intf.cb disable iff(intf.cb.reset) (intf.cb.Wr_enable & ~$past(intf.full)) |=> ((intf.cb.write_ptr-1'b1) == $past(intf.cb.write_ptr))) 
      $display("wr_ptr_inc PASSED"); else $display("wr_ptr_inc FAILED");

    // When the Write_enable signal is asserted and the FIFO is full, the write pointer shouldn't increment.
    wr_ptr_notinc: assert property (@intf.cb disable iff(intf.cb.reset) (intf.cb.Wr_enable & $past(intf.full)) |=> $stable(intf.cb.write_ptr)) 
                $display("wr_ptr_notinc PASSED"); else $display("wr_ptr_notinc FAILED");

    // When the Read_enable signal is asserted and the FIFO is not empty, the read pointer should increment.
    rd_ptr_inc: assert property (@intf.cb disable iff(intf.cb.reset) (intf.cb.Read_enable & ~$past(intf.empty)) |=> ((intf.cb.read_ptr-1'b1) == $past(intf.cb.read_ptr))) 
                $display("rd_ptr_inc PASSED"); else $display("rd_ptr_inc FAILED");

    // When the Read_enable signal is asserted and the FIFO is empty, the read pointer shouldn't increment.
    rd_ptr_notinc: assert property (@intf.cb disable iff(intf.cb.reset) (intf.cb.Read_enable & $past(intf.empty)) |=> $stable(intf.cb.read_ptr)) 
                $display("rd_ptr_notinc PASSED"); else $display("rd_ptr_notinc FAILED");

    // When the Reset is asserted, the write & read pointers, Data_Out, and the Flags should reset.
    resettingclk: assert property (@intf.cb intf.cb.reset |-> (!intf.cb.read_ptr & !intf.cb.write_ptr & !intf.cb.data_out & intf.empty & !intf.full))
                $display("resetting PASSED"); else $display("resetting FAILED");
    resettingnoclk: assert property (@intf.cb.reset intf.cb.reset |-> (!intf.cb.read_ptr & !intf.cb.write_ptr & !intf.cb.data_out & intf.empty & !intf.full))
                $display("resetting PASSED"); else $display("resetting FAILED");
      
    // When writing exceeds its capacity, the Full flag should be active.   
    full_flag: assert property (@intf.cb disable iff(intf.cb.reset) &(intf.read_ptr ~^ (intf.write_ptr+1)) |-> (intf.full))
                $display("full_flag PASSED"); else $display("full_flag FAILED");

    // When reading exceeds its capacity, the Empty flag should be active.
    empty_flag: assert property (@intf.cb disable iff(intf.cb.reset) &(intf.write_ptr ~^ intf.read_ptr) |-> (intf.empty))
                $display("empty_flag PASSED"); else $display("empty_flag FAILED");

    // When Writing into the FIFO and it is not full, the Value should appear in its memory.
    wr_data_fifo: assert property (@intf.cb disable iff(intf.cb.reset) (intf.cb.Wr_enable & ~$past(intf.full)) |=> ($past(intf.cb.data_in) == intf.cb.fifo[$past(intf.cb.write_ptr)])) 
                  $display("wr_data_fifo PASSED"); else $display("wr_data_fifo FAILED");
      
    // When Writing into the FIFO and it is full, the memory data should not change.
    wr_nodata_fifo: assert property (@intf.cb disable iff(intf.cb.reset) (intf.cb.Wr_enable & $past(intf.full)) |=> ($past(intf.cb.fifo[(intf.cb.write_ptr)]) == intf.cb.fifo[$past(intf.cb.write_ptr)])) 
                  $display("wr_nodata_fifo PASSED"); else $display("wr_nodata_fifo FAILED");

    // When Reading from the FIFO and it is not empty, the Value from its memory should appear on the output.
    rd_data_fifo: assert property (@intf.cb disable iff(intf.cb.reset) (intf.cb.Read_enable & ~$past(intf.empty))  |=> (intf.cb.data_out == intf.cb.fifo[$past(intf.cb.read_ptr)])) 
                  $display("rd_data_fifo PASSED"); else $display("rd_data_fifo FAILED");

    // When Reading from the FIFO and it is empty, the Value at its output should not change.
    rd_nodata_fifo: assert property (@intf.cb disable iff(intf.cb.reset) (intf.cb.Read_enable & $past(intf.empty)) |=> $stable(intf.cb.data_out))
                  $display("rd_nodata_fifo PASSED"); else $display("rd_nodata_fifo FAILED");

    flag_cg fcg;
    initial begin
      fcg = new();
      randata = new();
      // Resetting the FIFO
      repeat(2) begin 
        intf.cb.reset <= 1;
        @intf.cb;
	intf.cb.data_in <= 0;
        intf.cb.reset <= 0;
        intf.cb.Read_enable <= 0;
        intf.cb.Wr_enable <= 0;
        @intf.cb;
      end
      // Driving the FIFO inputs with constrained random values
      repeat(500) @intf.cb begin
        randata.randomize();
        intf.cb.data_in <= randata.data;
        intf.cb.Read_enable <= randata.read;
        intf.cb.Wr_enable <= randata.write;
      end
      // Resetting the FIFO
      repeat(2) begin 
        intf.cb.reset <= 1;
        @intf.cb;
	intf.cb.data_in <= 0;
        intf.cb.reset <= 0;
        intf.cb.Read_enable <= 0;
        intf.cb.Wr_enable <= 0;
        @intf.cb;
      end
      // Driving the FIFO inputs with constrained random values
      repeat(500) @intf.cb begin
        randata.randomize();
        intf.cb.data_in <= randata.data;
        intf.cb.Read_enable <= randata.read;
        intf.cb.Wr_enable <= randata.write;
      end
      $finish();
    end
endmodule
