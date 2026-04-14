module top_module (
    input clk,
    input reset,
    output reg [4:0] q
);

    // Ring counter logic
    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;
        else
            q <= {q[3:0], q[4]};
    end

endmodule