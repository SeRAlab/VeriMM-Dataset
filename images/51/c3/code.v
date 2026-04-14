module top_module(
    input a,
    input b,
    input clk,
    input reset,
    output [3:0] Q,
    output reg out_comb
);reg [3:0] johnson_counter;
reg [63:0] shift_register;
wire xor_result;

// XOR gate implementation
assign xor_result = a ^ b; // Change to continuous assignment

// Johnson counter implementation
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        johnson_counter <= 4'b0000;
        shift_register <= 64'b0;
    end else begin
        johnson_counter <= {johnson_counter[2:0], johnson_counter[3]} ^ johnson_counter[0];
        shift_register <= {shift_register[62:0], johnson_counter[3]};
    end
end

// Functional module implementation
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        out_comb <= 1'b0;
    end else begin
        out_comb <= xor_result ^ shift_register[3:0];
    end
end

assign Q = johnson_counter;

endmodule