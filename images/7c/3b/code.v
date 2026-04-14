module top_module(
    input clk,
    input reset,
    input [1:0] sel, // 2-bit input for the decoder
    input [3:0] a, b, // 4-bit inputs for the multiplier
    output reg [7:0] product, // 8-bit output from the multiplier
    output reg [15:0] out // 16-bit output from the decoder
);reg [15:0] decoder_out;
reg [3:0] multiplier_out;
integer i; // Declare the variable i

// 4-to-16 decoder
always @ (sel) begin
    case (sel)
        2'b00: decoder_out = 16'b1111111111111110;
        2'b01: decoder_out = 16'b1111111111111101;
        2'b10: decoder_out = 16'b1111111111111011;
        2'b11: decoder_out = 16'b1111111111110111;
        default: decoder_out = 16'b0; // Default case to avoid latches
    endcase
end

// 4-bit multiplier using shift-and-add method
always @(posedge clk) begin
    if (reset) begin
        product <= 8'b0;
        multiplier_out <= 4'b0;
    end else begin
        product <= 8'b0; // Reset product at each clock cycle
        multiplier_out <= a;
        for (i = 0; i < 4; i = i + 1) begin
            if (b[i] == 1) begin
                product <= product + (multiplier_out << i);
            end
        end
    end
end

// Output from selected decoder output used as one of the inputs to the multiplier
always @ (decoder_out or sel) begin // Use sel in sensitivity list to avoid latch
    case (sel)
        2'b00: product[7:0] <= decoder_out[7:0];
        2'b01: product[7:0] <= decoder_out[15:8];
        2'b10: product[7:0] <= decoder_out[11:4];
        2'b11: product[7:0] <= decoder_out[15:8];
        default: product[7:0] <= 8'b0; // Default case to avoid latches
    endcase
end

// Output from the decoder
assign out = decoder_out;

endmodule