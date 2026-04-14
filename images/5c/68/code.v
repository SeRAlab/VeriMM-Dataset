module down_counter (
    input clk,
    input load,
    input [4:0] load_value,
    output reg [4:0] count
);always @(posedge clk) begin
    if (load) begin
        count <= load_value;
    end else begin
        count <= count - 1;
    end
end

endmodule