module round_robin_arbiter (
    input wire clk,
    input wire rst,
    input wire req0,
    input wire req1,
    output reg gnt0,
    output reg gnt1
);
    reg last_granted; // 0 for req0, 1 for req1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gnt0 <= 0;
            gnt1 <= 0;
            last_granted <= 0;
        end else begin
            if (req0 && (last_granted == 1)) begin
                gnt0 <= 1;
                gnt1 <= 0;
                last_granted <= 0;
            end else if (req1 && (last_granted == 0)) begin
                gnt0 <= 0;
                gnt1 <= 1;
                last_granted <= 1;
            end else begin
                gnt0 <= 0;
                gnt1 <= 0;
            end
        end
    end
endmodule