module up_counter (
    input wire clk,
    input wire rstn,
    input wire load,
    input wire [3:0] load_val,
    output reg [3:0] count
);

always @(posedge clk)
begin
    if (~rstn)
        count <= 4'b0000;
    else if (load)
        count <= load_val;
    else
        count <= count + 1;
end

endmodule