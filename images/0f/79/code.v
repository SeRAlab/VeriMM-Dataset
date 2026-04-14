module power_gating (
    input wire ctrl,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    always @(*) begin
        if (ctrl) begin
            data_out = data_in;
        end else begin
            data_out = 5'b00000;
        end
    end
endmodule