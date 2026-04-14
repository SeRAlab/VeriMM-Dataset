module sync_counter(
    input clk,
    input rst,
    input load,
    input [3:0] load_val,

    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst)
        count <= 4'b0000;
    else if (load)
        count <= load_val;
    else
        count <= count + 1;
end

endmodule