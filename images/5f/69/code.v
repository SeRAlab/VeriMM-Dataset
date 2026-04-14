module top_module(
    input clk,
    input [6:0] offsetdelayctrlin,
    input [6:0] offset,
    input addnsub,
    input aload,
    output [6:0] offsetctrlout,
    output [6:0] offsettestout
);parameter use_offset = "false";
    parameter static_offset = 0;
    parameter use_pvt_compensation = "false";

    reg [6:0] delay;
    reg [6:0] offset_value;
    reg [6:0] compensated_offset;
    reg [6:0] offset_ctrl_out;
    reg [6:0] offset_test_out;

    always @(posedge clk) begin
        if (aload) begin
            delay <= offsetdelayctrlin;
        end else begin
            if (use_offset == "true" && static_offset == 0) begin
                if (addnsub) begin
                    delay <= offsetdelayctrlin + offset_value;
                end else begin
                    delay <= offsetdelayctrlin - offset_value;
                end
            end else if (static_offset != 0) begin
                delay <= offsetdelayctrlin + static_offset;
            end else begin
                delay <= offsetdelayctrlin;
            end
        end

        if (use_pvt_compensation == "true") begin
            compensated_offset <= offset_value + (delay[6] ? 7'b1111111 : 7'b0);
            offset_ctrl_out <= delay;
            offset_test_out <= compensated_offset + delay;
        end else begin
            offset_ctrl_out <= delay;
            offset_test_out <= delay + offset_value;
        end
    end

    always @(offset) begin
        offset_value <= offset;
    end

    assign offsetctrlout = offset_ctrl_out;
    assign offsettestout = offset_test_out;

endmodule