module top_module (
    input clk,
    input rst,
    input up_dn,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (rst)
            count <= 4'b0000;
        else if (up_dn)
            count <= count + 1;
        else
            count <= count - 1;
    end
endmodule