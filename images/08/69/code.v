module power_gating_controller (
    input wire enable,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    always @(*) begin
        if (enable) begin
            data_out = data_in;
        end else begin
            data_out = 5'b00000;
        end
    end
endmodule