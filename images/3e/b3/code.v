module qam_modulator (
    input clk,
    input rst,
    input [3:0] symbols, // 4-bit input for I and Q
    output reg [1:0] outI, // Amplitude for I
    output reg [1:0] outQ  // Amplitude for Q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        outI <= 2'b00;
        outQ <= 2'b00;
    end else begin
        case (symbols[3:2]) // I symbol
            2'b00: outI <= 2'b01; // +1
            2'b01: outI <= 2'b10; // +1
            2'b10: outI <= 2'b11; // -1
            2'b11: outI <= 2'b00; // -1
            default: outI <= 2'b00;
        endcase
        
        case (symbols[1:0]) // Q symbol
            2'b00: outQ <= 2'b01; // +1
            2'b01: outQ <= 2'b10; // -1
            2'b10: outQ <= 2'b11; // +1
            2'b11: outQ <= 2'b00; // -1
            default: outQ <= 2'b00;
        endcase
    end
end
endmodule