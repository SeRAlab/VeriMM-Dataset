module top_module(
    input clk,
    input wrdata_en,
    input [1:0] wrdata,
    output reg dq,        // Changed output to reg type
    output reg dq_oe_n    // Changed output to reg type
);reg odd;

    always @(posedge clk) begin
        if (wrdata_en) begin
            odd <= ~odd;
            if (odd) begin
                dq <= wrdata[1];
            end else begin
                dq <= wrdata[0];
            end
            dq_oe_n <= 1'b0;
        end else begin
            odd <= 1'b0;
            dq_oe_n <= 1'b1;
        end
    end

endmodule