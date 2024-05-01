package randpack;
    class ranData;
        rand logic [31:0] data;
        rand logic read, write;

        // Constraining the Data In signal randomization
        constraint C1 { data[7:0] inside {[100:230]}; }
        constraint C2 { data[15:8] >= 200; }
        constraint C3 {
            data[23:16] dist {
                [0:100]		:/ 30 ,
                [101:200]	:/ 60 ,
                [201:255]	:/ 10
            };
        }
        constraint C4 { if (data[7:0] > 150) data[31:24] <= 50; }

        // Constraining the Read and Write Enable signals randomization
        constraint C5 { 		
            {read, write} dist { 0 		:= 5,
                                 1  	:= 60,
                                 2      := 20,
                                 3 		:= 15
        }; }
    endclass
endpackage