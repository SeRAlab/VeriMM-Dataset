module top_module(
    input CLK,
    input RST_N,
    input START,
    input STOP,
    output reg [15:0] DATA_OUT
);reg [15:0] state;

always @(posedge CLK) begin
    if (RST_N == 0) begin
        state <= 16'h0000;
        DATA_OUT <= 16'h0000;
    end else if (START) begin
        state <= 16'h0000;
        DATA_OUT <= state;
    end else if (STOP) begin
        state <= 16'h0000;
        DATA_OUT <= 16'h0000;
    end else begin
        state <= {state[13:0], state[15]^state[13]};
        DATA_OUT <= state;
    end
end

endmodule