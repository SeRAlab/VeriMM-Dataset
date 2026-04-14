module top_module(
    input wire[3:0] value,
    input wire auxValue,
    output reg[6:0] segments
    );always @ (*) begin
    if (auxValue) begin
        case (value)
            4'h1: segments = 7'h73; // P
            4'h2: segments = 7'h78; // T
            4'h3: segments = 7'h50; // R
            4'h4: segments = 7'h1C; // V
            4'h5: segments = 7'h76; // H
            4'h6: segments = 7'h38; // L
            default: segments = 7'b0;
        endcase
    end
    else begin 
        case (value)
            4'h0: segments = 7'h3F; // 0
            4'h1: segments = 7'h06; // 1
            4'h2: segments = 7'h5B; // 2
            4'h3: segments = 7'h4F; // 3
            4'h4: segments = 7'h66; // 4
            4'h5: segments = 7'h6D; // 5
            4'h6: segments = 7'h7D; // 6
            4'h7: segments = 7'h07; // 7
            4'h8: segments = 7'h7F; // 8
            4'h9: segments = 7'h6F; // 9
            4'hA: segments = 7'h77; // A
            4'hB: segments = 7'h7C; // B
            4'hC: segments = 7'h39; // C
            4'hD: segments = 7'h5E; // D
            4'hE: segments = 7'h79; // E
            4'hF: segments = 7'h71; // F
            default: segments = 7'b0;
        endcase
    end
end
endmodule