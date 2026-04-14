module temp_shutdown(
    input clk,
    input reset,
    input [3:0] temp,
    output reg shutdown
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else if (temp > 4'd10) begin
            shutdown <= 1;
        end else begin
            shutdown <= 0;
        end
    end
endmodule