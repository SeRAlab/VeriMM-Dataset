module sipo_shift_register (  
    input wire clk,  
    input wire rst,  
    input wire si,  
    input wire load,  
    output reg [4:0] parallel_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 5'b00000;  
        end else begin  
            shift_reg <= {shift_reg[3:0], si};  
        end  
    end  

    always @(posedge clk) begin  
        if (load) begin  
            parallel_out <= shift_reg;  
        end  
    end  
endmodule