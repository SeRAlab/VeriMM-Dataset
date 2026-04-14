module sipo_shift_register (  
    input wire clk,  
    input wire load,  
    input wire serial_in,  
    output reg [4:0] parallel_out  
);  
    reg [4:0] shift_reg;  

    always @(posedge clk) begin  
        if (load) begin  
            shift_reg <= {shift_reg[3:0], serial_in};  
        end  
    end  

    always @(posedge clk) begin  
        if (load) begin  
            parallel_out <= shift_reg;  
        end  
    end  
endmodule