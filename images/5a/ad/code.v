module top_module(
    input clk,
    input rst,
    input [9:0] x,
    input [9:0] y,
    input hsync,
    input vsync,
    output reg [7:0] r,
    output reg [7:0] g,
    output reg [7:0] b
);reg [9:0] h_count;
reg [9:0] v_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        h_count <= 10'h0;
        v_count <= 10'h0;
    end else begin
        if (hsync == 0) begin
            if (h_count == 799) begin
                h_count <= 10'h0;
                if (vsync == 0) begin
                    if (v_count == 524) begin
                        v_count <= 10'h0;
                    end else begin
                        v_count <= v_count + 1;
                    end
                end
            end else begin
                h_count <= h_count + 1;
            end
        end
    end
end

reg [7:0] color;

always @(*) begin
    if (h_count < 8 || h_count >= 792 || v_count < 8 || v_count >= 488) begin
        color = 8'h0;
    end else if (h_count < 648) begin
        color = {8'h0, 8'h0, h_count[5:0]};
    end else begin
        color = {8'h0, 8'h0, 8'hff - (h_count[5:0] - 8'h8)};
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        r <= 8'h0;
        g <= 8'h0;
        b <= 8'h0;
    end else begin
        if (hsync == 0 && vsync == 0) begin
            r <= color;
            g <= color;
            b <= color;
        end else begin
            r <= 8'h0;
            g <= 8'h0;
            b <= 8'h0;
        end
    end
end

endmodule