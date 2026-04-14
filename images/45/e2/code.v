module down_counter(
    input clk,
    input rst_n,
    input en,
    output reg [4:0] count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 5'b11111;
        else if (en)
            count <= count - 1;
    end

endmodule