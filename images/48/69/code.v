module johnson_counter(
    input wire clk,
    input wire rst,
    input wire en,
    input wire clr,
    output reg [3:0] johnson_code
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        johnson_code <= 4'b0000;
    end else if (clr) begin
        johnson_code <= 4'b0000;
    end else if (en) begin
        johnson_code <= {~johnson_code[0], johnson_code[3:1]};
    end
end

endmodule