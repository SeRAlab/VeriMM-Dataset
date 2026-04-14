module top_module(
    input clk,
    input rst,
    input [WIDTH-1:0] input_l_tdata,
    input [WIDTH-1:0] input_r_tdata,
    input input_tvalid,
    output reg input_tready,
    output reg sck,
    output reg ws,
    output reg sd
);parameter WIDTH = 16;

reg [WIDTH-1:0] l_data;
reg [WIDTH-1:0] r_data;
reg [3:0] bit_count;
reg [1:0] channel_count;

always @(posedge clk) begin
    if (rst) begin
        input_tready <= 1'b0;
        sck <= 1'b0;
        ws <= 1'b0;
        sd <= 1'b0;
        l_data <= {WIDTH{1'b0}};
        r_data <= {WIDTH{1'b0}};
        bit_count <= 4'd0;
        channel_count <= 2'd0;
    end else begin
        if (input_tvalid && input_tready) begin
            input_tready <= 1'b0;
            l_data <= input_l_tdata;
            r_data <= input_r_tdata;
            bit_count <= 4'd0;
            channel_count <= 2'd0;
        end else if (sck && ws) begin
            if (bit_count == WIDTH-1) begin
                if (channel_count == 2'd0) begin
                    sd <= l_data[WIDTH-1-bit_count];
                    channel_count <= 2'd1;
                end else begin
                    sd <= r_data[WIDTH-1-bit_count];
                    channel_count <= 2'd0;
                end
                bit_count <= 4'd0;
            end else begin
                bit_count <= bit_count + 1;
                sd <= 1'b0;
            end
        end
        if (!input_tvalid) begin
            input_tready <= 1'b1;
        end
        sck <= ~sck;
        ws <= (bit_count == WIDTH-1) ? ~ws : ws;
    end
end

endmodule