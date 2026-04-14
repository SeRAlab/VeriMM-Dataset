module johnson_counter(
    input clk,
    input rst,
    input en,
    output reg [3:0] johnson
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            johnson <= 4'b0000;
        else if (en)
            johnson <= {~johnson[0], johnson[3:1]};
    end

endmodule