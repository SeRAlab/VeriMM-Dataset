module counter6bit_en_load (
    input clk,
    input rst,
    input en,
    input load,
    input [5:0] load_value,
    output reg [5:0] count
);always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 6'b000000;
    end else if (load) begin
        count <= load_value;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule