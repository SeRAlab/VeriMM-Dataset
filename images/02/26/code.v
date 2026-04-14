module serializer_8bit (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    output reg serial_out  
);  
    reg [2:0] count; // 3-bit counter to keep track of the number of bits output  
    reg [7:0] shift_reg; // 8-bit shift register  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 3'd0;  
            shift_reg <= data_in;  
            serial_out <= 1'b0;  
        end else if (count < 3'd8) begin  
            serial_out <= shift_reg[7]; // Output the MSB  
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left  
            count <= count + 1;  
        end else begin  
            serial_out <= 1'b0; // After 8 bits, output 0  
        end  
    end  
endmodule