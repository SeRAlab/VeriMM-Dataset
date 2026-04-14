module binary_counter(
    input clk,
    input rst_n,
    input load,
    input [3:0] data_in,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 4'b0000; // reset counter to 0
    else if (load)
        count <= data_in; // load data_in value
    else
        count <= count + 1; // increment counter
end

endmodule