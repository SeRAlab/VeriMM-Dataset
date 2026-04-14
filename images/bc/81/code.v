module up_down_counter (
    input wire clk,
    input wire rstn,
    input wire en,
    input wire up_dn,
    output reg [3:0] count
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        count <= 4'b0000;
    else if (en) begin
        if (up_dn)
            count <= count + 1'b1;
        else
            count <= count - 1'b1;
    end
end

endmodule