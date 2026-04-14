module johnson_counter(
    input clk,
    input sync_reset,
    output reg [8:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 9'b100000000;
        else
            count_out <= {count_out[7:0], ~count_out[8]};
    end

endmodule