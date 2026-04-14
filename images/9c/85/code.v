module johnson_counter(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [3:0] johnson_code
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        johnson_code <= 4'b0000;
    end else if (en) begin
        johnson_code <= {johnson_code[2:0], ~johnson_code[3]};
    end
end

endmodule