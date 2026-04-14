module top_module(
    input wire clk,        // Added missing clock input
    input wire reset,
    output reg out1,
    output reg out2
);reg [8:0] state;         // Changed `state` from wire to reg

always @ (posedge clk or negedge reset) begin
    if (reset == 1'b0) begin
        out1 <= 0;
        out2 <= 0;
        state <= 0;
    end else begin
        state <= state + 1;
        if (state % 2 == 0) begin
            out1 <= 0;
            out2 <= 1;
        end else begin
            out1 <= 1;
            out2 <= 0;
        end
    end
end

endmodule