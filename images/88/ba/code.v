module binary_counter (
    input wire clk,
    input wire rstn,
    input wire en,
    output reg [3:0] count
);

always @(posedge clk or negedge rstn) begin
    if (!rstn)
        count <= 4'b0000;
    else if (en)
        count <= count + 1'b1;
end

endmodule