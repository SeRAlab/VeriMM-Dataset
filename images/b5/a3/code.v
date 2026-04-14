module top_module(
    clk,
    reset,
    ce,
    a,
    b,
    op,
    s
);parameter ID = 32'd1;
parameter NUM_STAGE = 32'd1;
parameter WIDTH = 16;

input clk;
input reset;
input ce;
input signed [WIDTH-1:0] a;
input signed [WIDTH-1:0] b;
input op;
output signed [WIDTH-1:0] s;

// Create a pipeline register for the op signal
reg op_reg;
always @(posedge clk) begin
    if (reset) begin
        op_reg <= 0;
    end else begin
        op_reg <= op;
    end
end

// Create a pipeline register for the a signal
reg signed [WIDTH-1:0] a_reg;
always @(posedge clk) begin
    if (reset) begin
        a_reg <= 0;
    end else begin
        a_reg <= a;
    end
end

// Create a pipeline register for the b signal
reg signed [WIDTH-1:0] b_reg;
always @(posedge clk) begin
    if (reset) begin
        b_reg <= 0;
    end else begin
        b_reg <= b;
    end
end

// Create a pipeline register for the s signal
reg signed [WIDTH-1:0] s_reg;
always @(posedge clk) begin
    if (reset) begin
        s_reg <= 0;
    end else if (ce) begin
        if (op_reg == 0) begin
            s_reg <= a_reg + b_reg;
        end else begin
            s_reg <= a_reg - b_reg;
        end
    end
end

assign s = s_reg;

endmodule