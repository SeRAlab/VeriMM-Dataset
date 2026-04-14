module piso_shift_register (  
    input clk,  
    input reset,  
    input load,  
    input [4:0] parallel_in,  
    output reg serial_out  
);  
    reg [4:0] shift_reg;  
    integer count;  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 5'b0;  
            count <= 0;  
            serial_out <= 0;  
        end  
        else if (load) begin  
            shift_reg <= parallel_in;  
            count <= 0;  
        end  
        else if (count < 5) begin  
            serial_out <= shift_reg[4];  
            shift_reg <= shift_reg << 1;  
            count <= count + 1;  
        end  
    end  
endmodule