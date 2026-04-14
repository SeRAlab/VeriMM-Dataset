module shift_register (  
    input clk,  
    input rst,  
    input serial_in,  
    output reg [3:0] shift_reg,  
    output reg serial_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 4'b0000;  
            serial_out <= 1'b0;  
        end else begin  
            serial_out <= shift_reg[0];  
            shift_reg <= {serial_in, shift_reg[3:1]};  
        end  
    end  
endmodule