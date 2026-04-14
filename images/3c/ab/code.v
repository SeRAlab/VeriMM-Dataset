module shift_register_2bit(  
    input clk,  
    input reset,  
    input [1:0] data_in,  
    output reg [1:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= data_in;  
        end else begin  
            data_out <= {1'b0, data_out[1]}; // Shift right  
        end  
    end  
endmodule