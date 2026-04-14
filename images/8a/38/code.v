module johnson_counter_5bit (
    input clk,
    input en,
    input rst,
    output reg [4:0] count
);

    always @(posedge clk) begin
        if (rst)
            count <= 5'b00000;
        else if (en)
            count <= {count[3:0], ~count[4]};
    end
endmodule