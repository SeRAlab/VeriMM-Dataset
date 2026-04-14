module binary_counter_5bit_load(
    input clk,
    input rst,
    input load,
    input [4:0] load_val,
    output reg [4:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 5'b00000;
    end else if (load) begin
        count <= load_val;
    end else begin
        count <= count + 1;
    end
end

endmodule