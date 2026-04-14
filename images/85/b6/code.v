module top_module(
    input clk,
    input din,
    input reset_n,
    output dout
);reg dff_input;
    reg dff_output;

    always @ (posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            dff_input <= 1'b0;
            dff_output <= 1'b0; // Reset output as well
        end else begin
            dff_input <= din;
            dff_output <= dff_input; // Capture input in output
        end
    end

    assign dout = dff_output;

endmodule