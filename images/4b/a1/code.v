module counter12bit_sync_load (
    input clk,
    input rst,
    input load,
    input [11:0] load_value,
    output reg [11:0] count
);always @(posedge clk) begin
    if (rst) begin
        count <= 12'b000000000000;
    end else if (load) begin
        count <= load_value;
    end else begin
        count <= count + 1;
    end
end

endmodule