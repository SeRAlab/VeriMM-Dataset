module top_module(
    input reset,
    input clk,
    input [7:0] data_in,
    output reg mosi,
    input miso,
    output reg ready
);reg [7:0] buffer;
    reg [2:0] cnt;
    reg [7:0] data;
    
    always @(posedge clk) begin
        if (reset) begin
            buffer <= 8'h00;
            cnt <= 3'h0;
            data <= 8'h00;
            mosi <= 1'b0;
            ready <= 1'b0;
        end else begin
            if (cnt == 3'h0) begin
                buffer <= data_in;
                mosi <= buffer[7];
                cnt <= 3'h1;
            end else if (cnt == 3'h7) begin
                buffer <= {buffer[6:0], miso};
                cnt <= 3'h0;
                data <= data + 8'h01;
                if (data == 8'hff) begin
                    ready <= 1'b1;
                end
            end else begin
                buffer <= {buffer[6:0], mosi};
                mosi <= buffer[7];
                cnt <= cnt + 3'h1;
            end
        end
    end

endmodule