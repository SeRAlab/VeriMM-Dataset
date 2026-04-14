module shift_register(clk, reset, dir, data_in, data_out);  
    input clk;  
    input reset;  
    input dir;  
    input [1:0] data_in;  
    output reg [1:0] data_out;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 2'b00;  
        end else begin  
            if (dir) begin  
                data_out <= {data_out[0], data_in[1]};  // Shift right  
            end else begin  
                data_out <= {data_in[0], data_out[1]};  // Shift left  
            end  
        end  
    end  
endmodule