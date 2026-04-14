module top_module(
    input CLK,
    input RST,
    output reg [5:0] SEC,
    output reg [5:0] MIN,
    output reg [4:0] HOUR
);always @(*) begin
        if (RST) begin
            SEC <= 6'b0;
            MIN <= 6'b0;
            HOUR <= 5'b0;
        end else begin
            SEC <= SEC + 1;
            if (SEC == 6'd60) begin
                SEC <= 6'b0;
                MIN <= MIN + 1;
                if (MIN == 6'd60) begin
                    MIN <= 6'b0;
                    HOUR <= HOUR + 1;
                    if (HOUR == 5'd24) begin
                        HOUR <= 5'b0;
                    end
                end
            end
        end
    end
    
endmodule