module sipo_shift_register (  
    input clk,  
    input reset_n,  
    input serial_in,  
    output reg [3:0] parallel_out  
);  
    reg [3:0] shift_reg;  

    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n)  
            shift_reg <= 4'b0000;  
        else  
            shift_reg <= {shift_reg[2:0], serial_in};  
    end  

    always @(posedge clk) begin  
        parallel_out <= shift_reg;  
    end  
endmodule