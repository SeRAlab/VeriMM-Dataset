module PISO_Shift_Register(  
    input wire clk,  
    input wire load,  
    input wire [7:0] parallel_in,  
    output reg serial_out  
);  
    reg [7:0] shift_reg;  
  
    always @(posedge clk) begin  
        if (load)  
            shift_reg <= parallel_in;  
        else  
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left, entering 0  
    end  
  
    always @(posedge clk) begin  
        serial_out <= shift_reg[7]; // Output the MSB  
    end  
endmodule