module sipo_shift_register(  
    input wire clk,  
    input wire rst_n,  
    input wire shift_en,  
    input wire serial_in,  
    output reg [4:0] parallel_out  
);  

    reg [4:0] shift_reg;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            shift_reg <= 5'b00000;  
        end else if (!shift_en) begin  
            shift_reg <= {shift_reg[3:0], serial_in};  
        end  
    end  

    always @(*) begin  
        parallel_out = shift_reg;  
    end  
endmodule