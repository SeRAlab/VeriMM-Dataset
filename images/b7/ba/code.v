module dff_en (
    input wire clk,
    input wire rstn,
    input wire en,
    input wire d,
    output reg q
);

always @(posedge clk or negedge rstn)
begin
    if (~rstn)
        q <= 1'b0;
    else if (en)
        q <= d;
end

endmodule