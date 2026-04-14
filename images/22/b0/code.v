module counter_2bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [1:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 2'b00; // reset the counter
    end else if (en) begin
        count <= count + 1; // increment the counter
    end
end

endmodule