module binary_up_down_counter(
    input wire clk,
    input wire rst_n,
    input wire en,
    input wire up_down,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 4'd0;
    else if (en) begin
        if (up_down)
            count <= count + 4'd1;
        else
            count <= count - 4'd1;
    end
end

endmodule