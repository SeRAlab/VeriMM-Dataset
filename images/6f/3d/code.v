module shift_register#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        data_out <= 0;
    end else if (load) begin
        data_out <= data_in;
    end else if (en) begin
        data_out <= data_out << 1;
    end
end

endmodule