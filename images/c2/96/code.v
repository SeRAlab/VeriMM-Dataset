module sum16 (
    input [31:0] data_in,
    input en,
    output reg [15:0] data_out,
    output reg ovf
);

    always @(*) begin
        if (en == 1) begin
            data_out = data_in[31:16] + data_in[15:0];
            if (data_out > 16'hFFFF) begin
                ovf = 1;
            end else begin
                ovf = 0;
            end
        end else begin
            data_out = 16'h0000;
            ovf = 0;
        end
    end

endmodule