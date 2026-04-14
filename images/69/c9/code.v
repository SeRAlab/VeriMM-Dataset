module johnson_counter (
    input wire clk,
    input wire rstn,
    output reg [2:0] q
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        q <= 3'b000;
    else
        q <= {~q[2], q[2:1]};
end

endmodule