module prbs_generator(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [11:0] prbs_out
);

wire feedback = prbs_out[11] ^ prbs_out[10] ^ prbs_out[9] ^ prbs_out[3];

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        prbs_out <= 12'b000000000001;
    end else if (en) begin
        prbs_out <= {prbs_out[10:0], feedback};
    end
end

endmodule