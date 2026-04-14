module top_module(
    input logic [WIDTH-1:0] A, B,
    output logic [WIDTH-1:0] Y, R
);parameter WIDTH = 1;

wire [WIDTH*WIDTH-1:0] chaindata;

genvar i;
generate
    for (i = 0; i < WIDTH; i=i+1) begin : stage
        wire [WIDTH-1:0] stage_in;

        if (i == 0) begin : cp
            assign stage_in = A;
        end else begin : cp
            assign stage_in = chaindata[i*WIDTH-1:(i-1)*WIDTH];
        end

        assign Y[WIDTH-(i+1)] = stage_in >= {B, {WIDTH-(i+1){1'b0}}};
        assign chaindata[(i+1)*WIDTH-1:i*WIDTH] = Y[WIDTH-(i+1)] ? stage_in - {B, {WIDTH-(i+1){1'b0}}} : stage_in;
    end
endgenerate

assign R = chaindata[WIDTH*WIDTH-1:WIDTH*(WIDTH-1)];

endmodule