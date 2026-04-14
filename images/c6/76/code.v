module sync_counter (
    input clk,
    input [3:0] load,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= load;
        end
        else begin
            q <= q + 1;
        end
    end

endmodule