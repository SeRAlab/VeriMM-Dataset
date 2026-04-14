module shift_register(  
    input clk,  
    input rst,  
    input data_in,  
    output reg [15:0] shift_reg  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 16'b0;  
        end else begin  
            shift_reg <= {shift_reg[14:0], data_in};  
        end  
    end  
endmodule