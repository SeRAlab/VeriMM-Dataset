module top_module(
    input t,
    input clk,
    output reg [1:0] out
);reg [1:0] flip_flop;
wire d1, d2;

// T flip-flop 1
assign d1 = flip_flop[0] ^ t;
always @(posedge clk) begin
    flip_flop[0] <= d1;
end

// T flip-flop 2
assign d2 = flip_flop[1] ^ flip_flop[0];
always @(posedge clk) begin
    flip_flop[1] <= d2;
end

// Functional module
always @(*) begin
    case (flip_flop)
        2'b00: out = 2'b00;
        2'b01: out = 2'b01;
        2'b10: out = 2'b10;
        2'b11: out = 2'b11;
    endcase
end

endmodule