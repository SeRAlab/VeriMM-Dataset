module top_module(digit, drivers);input [3:0] digit;
    output [6:0] drivers;
    reg [6:0] drivers;

    always @(digit) begin
        case(digit)
            4'h0: drivers = 7'b0000001;
            4'h1: drivers = 7'b1001111;
            4'h2: drivers = 7'b0010010;
            4'h3: drivers = 7'b0000110;
            4'h4: drivers = 7'b1001100;
            4'h5: drivers = 7'b0100100;
            4'h6: drivers = 7'b0100000;
            4'h7: drivers = 7'b0001101;
            4'h8: drivers = 7'b0000000;
            4'h9: drivers = 7'b0000100;
            4'hA: drivers = 7'b0001000;
            4'hB: drivers = 7'b1100000;
            4'hC: drivers = 7'b0110001;
            4'hD: drivers = 7'b1000010;
            4'hE: drivers = 7'b0110000;
            4'hF: drivers = 7'b0111000;
            default: drivers = 7'b0000000;
        endcase
    end

endmodule