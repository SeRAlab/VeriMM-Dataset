module up_down_counter (
    input wire clk,
    input wire rstn,
    input wire en,
    input wire up_down,
    output reg [1:0] count
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        count <= 2'b00;
    else if (en) begin
        if (up_down)
            count <= count + 1'b1;
        else
            count <= count - 1'b1;
    end
end

endmodule