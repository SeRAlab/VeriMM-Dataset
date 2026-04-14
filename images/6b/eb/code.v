module top_module(
    input wire clk,
    input wire reset,
    input wire [15:0] in,
    output reg [7:0] final_output
);reg [7:0] upper_byte;
reg [7:0] lower_byte;
reg [7:0] xor_output; // Changed from wire to reg

// Sequential module to split input into upper and lower bytes
always @(posedge clk, posedge reset) begin
    if (reset) begin
        upper_byte <= 8'b0;
        lower_byte <= 8'b0;
    end else begin
        upper_byte <= in[15:8];
        lower_byte <= in[7:0];
    end
end

// Behavioral XOR gate
always @(*) begin
    if (upper_byte == lower_byte) begin
        xor_output = 8'b00000000; // Now this is valid as xor_output is a reg
    end else begin
        xor_output = 8'b11111111; // Now this is valid as xor_output is a reg
    end
end

// Structural XOR gate using MUX
wire [7:0] mux_output;
assign mux_output = (xor_output == 8'b11111111) ? lower_byte : upper_byte;

// Final output
always @(posedge clk, posedge reset) begin
    if (reset) begin
        final_output <= 8'b0;
    end else begin
        final_output <= mux_output;
    end
end

endmodule