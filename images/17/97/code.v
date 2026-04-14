module siso_shift_register (  
    input clk,  
    input reset,  
    input serial_in,  
    input enable,  
    output reg serial_out  
);  
    reg [3:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 4'b0000;  
        end else if (enable) begin  
            shift_reg <= {shift_reg[2:0], serial_in};  
        end  
    end  

    always @(posedge clk) begin  
        serial_out <= shift_reg[3];  
    end  
endmodule