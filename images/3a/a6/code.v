module barrel_shifter(input [7:0] data_in,  
                      input [2:0] shift_amount,  
                      input dir,  
                      output reg [7:0] data_out);  
    always @(*) begin  
        if (dir == 0) begin // Left shift  
            data_out = data_in << shift_amount;  
        end else begin // Right shift  
            data_out = data_in >> shift_amount;  
        end  
    end  
endmodule