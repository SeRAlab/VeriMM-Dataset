module top_module(
    input clk,
    input slowena,
    input reset,
    input select,
    input a,
    input b,
    output reg out
);reg [3:0] count;
wire xor_out;

// Decade counter
always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b0000;
    end else if (slowena) begin
        count <= count;
    end else begin
        count <= count + 1;
    end
end

// XOR gate
assign xor_out = a ^ b;

// Control logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 1'b0;
    end else begin
        if (select) begin
            out <= xor_out;
        end else begin
            out <= count[3];
        end
    end
end

endmodule