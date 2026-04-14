module top_module(
    input A,
    input clk,
    input reset,
    input VPB,
    input VPWR,
    input VGND,
    input VNB,
    output X
);reg [9:0] delay_counter;
    reg delayed_output;

    always @(posedge clk) begin
        if (reset == 1) begin
            delay_counter <= 0;
            delayed_output <= 0;
        end else if (delay_counter == 9) begin
            delayed_output <= A;
        end else begin
            delay_counter <= delay_counter + 1;
        end
    end

    assign X = delayed_output;

endmodule