module serializer_16bit (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    output reg [1:0] shift_out  
);  
    reg [15:0] shift_reg;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 16'b0;  
            shift_out <= 2'b0;  
        end else begin  
            shift_reg <= {shift_reg[13:0], data_in};  
            shift_out <= shift_reg[1:0];  
        end  
    end  
endmodule