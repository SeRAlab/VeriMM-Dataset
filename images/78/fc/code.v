module counter_4bit (
    input clk,
    input en,
    input rst,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 4'b0;
        else if (en)
            count <= count + 1;
    end
endmodule