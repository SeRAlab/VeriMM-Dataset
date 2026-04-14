module shift_register (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [1:0] shift_reg  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            shift_reg <= 2'b00;  
        else  
            shift_reg <= {serial_in, shift_reg[1]};  
    end  
endmodule