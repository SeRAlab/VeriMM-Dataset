module top_module(addr, dout);input [5:0] addr;
output [3:0] dout;

reg [3:0] dout;

always @(addr) begin
    case (addr)
        6'd0: dout = 4'd14;  // Changed from hex to decimal representation
        6'd1: dout = 4'd4;   // Changed from hex to decimal representation
        6'd2: dout = 4'd13;  // Changed from hex to decimal representation
        6'd3: dout = 4'd1;   // Changed from hex to decimal representation
        6'd4: dout = 4'd2;   // Changed from hex to decimal representation
        6'd5: dout = 4'd15;  // Changed from hex to decimal representation
        6'd6: dout = 4'd11;  // Changed from hex to decimal representation
        6'd7: dout = 4'd8;   // Changed from hex to decimal representation
        6'd8: dout = 4'd3;   // Changed from hex to decimal representation
        6'd9: dout = 4'd10;  // Changed from hex to decimal representation
        6'd10: dout = 4'd6;  // Changed from hex to decimal representation
        6'd11: dout = 4'd12; // Changed from hex to decimal representation
        6'd12: dout = 4'd5;  // Changed from hex to decimal representation
        6'd13: dout = 4'd9;  // Changed from hex to decimal representation
        6'd14: dout = 4'd0;  // Changed from hex to decimal representation
        6'd15: dout = 4'd7;  // Changed from hex to decimal representation
        default: dout = 4'd0; // Changed from hex to decimal representation
    endcase
end

endmodule