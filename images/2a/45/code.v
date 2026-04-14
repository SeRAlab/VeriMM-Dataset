module sipo_shift_register (  
    input clk,  
    input reset,  
    input serial_in,  
    output reg [4:0] parallel_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            shift_reg <= 5'b0;  
        else  
            shift_reg <= {shift_reg[3:0], serial_in};  
    end  

    always @(*) begin  
        parallel_out = shift_reg;  
    end  
endmodule