module dma_controller (
    input wire clk,
    input wire reset,
    input wire req1,
    input wire req2,
    output reg gnt1,
    output reg gnt2,
    output reg dt_en1,
    output reg dt_en2
);
    reg [1:0] active_channel; // 0: none, 1: channel 1, 2: channel 2

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            active_channel <= 0;
            gnt1 <= 0;
            gnt2 <= 0;
            dt_en1 <= 0;
            dt_en2 <= 0;
        end else begin
            dt_en1 <= 0;
            dt_en2 <= 0;

            if (req1 && !gnt1 && (active_channel == 0 || active_channel == 2)) begin
                active_channel <= 1;
                gnt1 <= 1;
                gnt2 <= 0;
                dt_en1 <= 1;
            end else if (req2 && !gnt2 && (active_channel == 0 || active_channel == 1)) begin
                active_channel <= 2;
                gnt1 <= 0;
                gnt2 <= 1;
                dt_en2 <= 1;
            end else if (active_channel == 1) begin
                gnt1 <= 0;
                gnt2 <= 0;
                active_channel <= 2; // Switch to channel 2 for next grant
            end else if (active_channel == 2) begin
                gnt1 <= 0;
                gnt2 <= 0;
                active_channel <= 1; // Switch to channel 1 for next grant
            end
        end
    end
endmodule