module down_counter (
    input clk,
    input rst_n, // active low reset
    input load,
    input [3:0] init_value,
    output reg [3:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 4'b0000; // reset to 0
    end else if (load) begin
        count <= init_value; // load new value
    end else if (count > 0) begin
        count <= count - 1; // count down
    end
end

endmodule