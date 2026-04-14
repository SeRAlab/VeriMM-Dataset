module top_module(
    input a,
    input b,
    input S,
    input areset,
    input [3:0] binary,
    output reg [3:0] abs_val,
    output reg [3:0] final_output   // Change wire to reg
);// 2-to-1 multiplexer
reg [3:0] Y;
always @(*) begin
    if (areset) begin
        Y <= 4'b0000;
    end else if (S == 0) begin
        Y <= a;
    end else begin
        Y <= b;
    end
end

// Absolute value module
always @(*) begin
    if (binary[3] == 1) begin
        abs_val = ~binary + 1;
    end else begin
        abs_val = binary;
    end
end

// Final output module
always @(*) begin
    if (areset) begin
        final_output = 4'b0000;
    end else begin
        final_output = abs_val;
    end
end

endmodule