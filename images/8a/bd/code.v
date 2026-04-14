module up_counter (
    input clk,
    input rst_n,
    input en,
    output reg [3:0] count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 4'd0;
        else if (en)
            count <= count + 1;
    end
endmodule