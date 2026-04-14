module binary_counter_load(
    input               clk,
    input               rst,
    input               load,
    input   [15:0]      load_val,

    output reg [15:0]   count
);

always@(posedge clk or posedge rst) begin
    if (rst)
        count <= 16'b0000000000000000;
    else if (load)
        count <= load_val;
    else
        count <= count + 1;
end

endmodule