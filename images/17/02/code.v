module pcie_signal_checker (
    input [4:0] signal_in,
    input control,
    output reg signal_out
);
    always @(*) begin
        if (control == 1'b1) begin
            signal_out = (signal_in == 5'b11111) ? 1'b1 : 1'b0;
        end else begin
            signal_out = (signal_in == 5'b00000) ? 1'b1 : 1'b0;
        end
    end
endmodule