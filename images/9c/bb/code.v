module top_module(
    input [3:0] data_in,
    output reg [2:0] data_out
);reg [2:0] memory [15:0];

initial begin
    memory[0] = 3'b011;
    memory[1] = 3'b000;
    memory[2] = 3'b101;
    memory[3] = 3'b010;
    memory[4] = 3'b111;
    memory[5] = 3'b001;
    memory[6] = 3'b100;
    memory[7] = 3'b110;
    memory[8] = 3'b010;
    memory[9] = 3'b100;
    memory[10] = 3'b001;
    memory[11] = 3'b111;
    memory[12] = 3'b110;
    memory[13] = 3'b011;
    memory[14] = 3'b000;
    memory[15] = 3'b101;
end

always @(*) begin
    data_out = memory[data_in];
end

endmodule