module sipo_shift_register (  
    input clk,  
    input rst_n,  
    input serial_in,  
    output reg [4:0] parallel_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            shift_reg <= 5'b00000;  
        end else begin  
            shift_reg <= {shift_reg[3:0], serial_in};  
        end  
    end  

    always @(posedge clk) begin  
        parallel_out <= shift_reg;  
    end  
endmodule