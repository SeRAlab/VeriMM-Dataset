module top_module(
    input clk,
    input d,
    output reg q );reg mux_out;
    reg latch_out;

    always @ (posedge clk) begin
        mux_out <= d;
    end

    always @ (mux_out) begin
        if (mux_out) begin
            latch_out <= 1'b1;
        end else begin
            latch_out <= 1'b0;
        end
    end

    always @ (posedge clk) begin
        q <= latch_out;
    end

endmodule