module top_module (
    input clk,
    input rst_n,
    input en,
    input d,
    output reg q
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0; // Reset output to 0
        else if (en)
            q <= d; // Transfer D to Q
    end

endmodule