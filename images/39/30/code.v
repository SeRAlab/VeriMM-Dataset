module shift_register (  
    input clk,  
    input reset,  
    input shift_left,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 16'b0;  
        end else begin  
            if (shift_left) begin  
                data_out <= {data_out[14:0], 1'b0}; // Shift left  
            end else begin  
                data_out <= {1'b0, data_out[15:1]}; // Shift right  
            end  
        end  
    end  
endmodule