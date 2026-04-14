module top_module(
    input [7:0] in,
    output reg [2:0] pos
);reg [2:0] pos_next;
wire highest_bit_detected;

// Combinational logic for detecting the highest bit
assign highest_bit_detected = (in[7] || in[6] || in[5] || in[4] || in[3] || in[2] || in[1] || in[0]);

always @(*) begin
    if (in[7]) pos_next = 3'b111;
    else if (in[6]) pos_next = 3'b110;
    else if (in[5]) pos_next = 3'b101;
    else if (in[4]) pos_next = 3'b100;
    else if (in[3]) pos_next = 3'b011;
    else if (in[2]) pos_next = 3'b010;
    else if (in[1]) pos_next = 3'b001;
    else if (in[0]) pos_next = 3'b000;
    else pos_next = 3'b000;
end

// Sequential logic for updating the output register
always @(posedge highest_bit_detected) begin
    pos <= pos_next;
end

endmodule