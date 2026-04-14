module bidirectional_shift_register#(
    parameter WIDTH = 10
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire dir,
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
        if (dir) begin
            data_out <= data_out >> 1;
        end else begin
            data_out <= data_out << 1;
        end
    end
end

endmodule