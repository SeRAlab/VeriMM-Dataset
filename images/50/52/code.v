module top_module(
    input [0:0] address,
    input clock,
    output reg [15:0] q  // Change output to reg
);reg [15:0] memory [0:1];

always @(posedge clock) begin
    if (address == 1'b0) begin
        q <= memory[0];
    end else begin
        q <= memory[1];
    end
end

always @(*) begin
    if (address == 1'b0) begin
        memory[0] = q; // This can stay as is
    end else begin
        memory[1] = q; // This can stay as is
    end
end

endmodule