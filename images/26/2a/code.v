module counter_2bit (
    input clk,
    input rst,
    input en,
    output reg [1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 2'b00; // Asynchronous reset
    end else if (en) begin
        count <= count + 1; // Increment the counter
    end
end

endmodule