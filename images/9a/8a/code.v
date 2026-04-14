module ring_counter(
    input clk,
    input sync_reset,
    output reg [4:0] count_out
);

    always @(posedge clk) begin
        if (sync_reset)
            count_out <= 5'b00001;
        else
            count_out <= {count_out[3:0], count_out[4]};
    end

endmodule