module ring_counter (
    input wire clk,
    input wire rstn,
    output reg [3:0] count
);

always @(posedge clk)
begin
    if (~rstn)
        count <= 4'b0001;
    else
        count <= {count[2:0], count[3]};
end

endmodule