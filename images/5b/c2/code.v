module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q,
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor,
    output reg [99:0] final_output
);reg [99:0] shifted_data;
wire [99:0] and_result;
wire [99:0] or_result;
wire [99:0] xor_result;

// Barrel shifter
always @ (posedge clk) begin
    if (load) begin
        case (ena)
            2'b00: shifted_data <= data;
            2'b01: shifted_data <= {data[99], data[99:1]};
            2'b10: shifted_data <= {data[98:0], data[0]};
            2'b11: shifted_data <= {data[98:0], data[1], data[0]};
        endcase
    end
end

// Combinational circuit
assign and_result = shifted_data & in;
assign or_result = shifted_data | in;
assign xor_result = shifted_data ^ in;

// Output ports
assign out_and = and_result[99];
assign out_or = or_result[99];
assign out_xor = xor_result[99];

// Final output
always @ (posedge clk) begin
    if (load) begin
        final_output <= and_result + xor_result;
    end
end

// Output register
always @ (posedge clk) begin
    if (load) begin
        q <= shifted_data;
    end
end

endmodule