module top_module(
  input [n-1:0] in,
  input clk,                   // Added clock signal input
  output reg [m-1:0] out       // Changed output to reg type
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter k = 4; // number of states

// Function to calculate log2 (for parameter usage)
function integer log2;
    input integer value;
    begin
        log2 = 0;
        while (value > 1) begin
            value = value >> 1;
            log2 = log2 + 1;
        end
    end
endfunction

reg [log2(k)-1:0] state; // register to hold current state
reg [log2(k)-1:0] next_state; // Change next_state to reg type

// State transition table
always @ (state or in) begin
    case (state)
        2'b00: next_state = (in == 2'b00) ? 2'b00 : 2'b01;
        2'b01: next_state = (in == 2'b00) ? 2'b10 : 2'b11;
        2'b10: next_state = (in == 2'b00) ? 2'b00 : 2'b11;
        2'b11: next_state = (in == 2'b00) ? 2'b10 : 2'b01;
        default: next_state = 2'b00; // Default state for safety
    endcase
end

// Assign outputs based on current state
always @ (state) begin
    case (state)
        2'b00: out = {m{1'b0}};
        2'b01: out = {m{1'b1}};
        2'b10: out = {out[1], ~out[0]};
        2'b11: out = {~out[1], out[0]};
        default: out = {m{1'b0}}; // Default to zeros for safety
    endcase
end

// Update state on clock edge
always @ (posedge clk) begin
    state <= next_state;
end

endmodule