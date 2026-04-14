module SIPO_Switch (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [4:0] parallel_out  
);  
    reg [4:0] shift_reg;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 5'b00000;  
        end else begin  
            shift_reg <= {shift_reg[3:0], serial_in};  
        end  
    end  
  
    always @(*) begin  
        parallel_out = shift_reg;  
    end  
endmodule