module piso_shift_register(  
    input clk,  
    input rst,  
    input load,  
    input [4:0] parallel_in,  
    output reg serial_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            shift_reg <= 5'b00000;  
            serial_out <= 1'b0;  
        end else if (load) begin  
            shift_reg <= parallel_in;  
        end else begin  
            serial_out <= shift_reg[0];  
            shift_reg <= {1'b0, shift_reg[4:1]};  
        end  
    end  
endmodule