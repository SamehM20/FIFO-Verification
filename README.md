# FIFO-Verification
The aim of this project is to use many features of SystemVerilog and to cover the FIFO Code and Functionality as much as possible.

#### Assertions: Verifying the following
- **"wr_ptr_inc"**: When the Write_enable signal is asserted and the FIFO is not full, the write pointer (write_ptr) should increment.

- **"wr_ptr_notinc"**: When the Write_enable signal is asserted and the FIFO is full, the write pointer (write_ptr) should not increment.
----> to check whether the write pointer (write_ptr) only increments with reason or just increments all the time.

- **"rd_ptr_inc"**: When the Read_enable signal is asserted and the FIFO is not empty, the read pointer (read_ptr) should increment. 
----> to check whether the read pointer (read_ptr) increments when reading data out.

- **"rd_ptr_notinc"**: When the Read_enable signal is asserted and the FIFO is empty, the read pointer (read _ptr) should not increment.
----> to check whether the read pointer (read_ptr) only increments with reason or just increments all the time.

- **"resettingnoclk"**: When the Reset is asserted away from the clock active edge, the write & read pointers, Data_Out, and the Flags should reset.
----> to check if the outputs and the pointers reset when the reset signal is asserted without the clock active edge, since it’s asynchronous reset.

- **"resettingclk"**: When the Reset is asserted at the time of a clock active edge, the write & read pointers, Data_Out, and the Flags should reset.
----> unlike the one before, this assertion checks the priority of the reset signal over the clock signal.

- **"full_flag"**: When writing exceeds its capacity, the Full flag should be active.
----> to check the full flag functionality.

- **"empty_flag"**: When reading exceeds its capacity, the Empty flag should be active.
----> to check the empty flag functionality.

- **"wr_data_fifo"**: When Writing into the FIFO and it is not full, the Value should appear in its memory.
----> this one completes the functionality check with “wr_ptr_inc” as it checks whether the value have been successfully written into memory or not (the other one only checked the pointer).

- **"wr_nodata_fifo"**: When Writing into the FIFO and it is full, the memory data should not change.
----> this one completes the functionality check with "wr_ptr_notinc" as it checks whether the memory data haven’t been overwritten by the value or not (the other one only checked the pointer).

- **"rd_data_fifo"**: When Reading from the FIFO and it is not empty, the Value from its memory should appear on the output.
----> this one completes the functionality check with "rd_ptr_inc" as it checks whether the memory data have been successfully appeared on the output port or not (the other one only checked the pointer).

- **"rd_nodata_fifo"**: When Reading from the FIFO and it is empty, the Value at its output should not change.
----> this one completes the functionality check with “rd_ptr_notinc” as it checks whether the output port data haven’t been overwritten by some garbage value or not (the other one only checked the pointer).

#### Coverage
The Code Coverage is 100% (Line, Transition, block, Conditional)
