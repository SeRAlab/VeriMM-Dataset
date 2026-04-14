module top_module(
    input clk,
    input reset_n,
    input in_valid,
    input [7:0] in_data,
    input [7:0] in_channel,
    input in_startofpacket,
    input in_endofpacket,
    output reg in_ready,
    input out_ready,
    output reg out_valid,
    output reg [7:0] out_data,
    output reg [7:0] out_channel,
    output reg out_startofpacket,
    output reg out_endofpacket
);reg [7:0] stored_data;
    reg [7:0] stored_channel;
    reg stored_startofpacket;
    reg stored_endofpacket;

    always @(posedge clk) begin
        if (reset_n == 0) begin
            in_ready <= 0;
            out_valid <= 0;
            out_data <= 0;
            out_channel <= 0;
            out_startofpacket <= 0;
            out_endofpacket <= 0;
        end else begin
            if (out_ready == 1 && in_valid == 1) begin
                stored_data <= in_data;
                stored_channel <= in_channel;
                stored_startofpacket <= in_startofpacket;
                stored_endofpacket <= in_endofpacket;
                in_ready <= 1;
            end else begin
                in_ready <= 0;
            end

            if (out_ready == 0) begin
                out_valid <= 0;
                out_data <= 0;
                out_channel <= 0;
                out_startofpacket <= 0;
                out_endofpacket <= 0;
            end else if (in_ready == 1) begin
                out_valid <= 1;
                out_data <= stored_data;
                out_channel <= stored_channel;
                out_startofpacket <= stored_startofpacket;
                out_endofpacket <= stored_endofpacket;

                if (in_channel > 0) begin
                    out_valid <= 0;
                    $display("Simulation Message: Channel %d is suppressed", in_channel);
                end
            end
        end
    end

endmodule