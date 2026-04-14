module loadable_counter(
    input clk,
    input load,
    input [3:0] data_in,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (load) begin
        count <= data_in;
    end else begin
        count <= count + 1;
    end
end

endmodule