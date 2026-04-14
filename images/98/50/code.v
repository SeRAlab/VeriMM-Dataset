module top_module(input [3:0] binary_in, output [1:0] binary_out);reg [1:0] out;
    
    always @(*) begin
        case(binary_in)
            4'b0000, 4'b0001, 4'b1000, 4'b1001: out = 2'b00;
            4'b0010, 4'b0011, 4'b1010, 4'b1011: out = 2'b01;
            4'b0100, 4'b0101, 4'b1100, 4'b1101: out = 2'b10;
            4'b0110, 4'b0111, 4'b1110, 4'b1111: out = 2'b11;
        endcase
    end
    
    assign binary_out = out;
endmodule