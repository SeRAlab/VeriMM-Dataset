module round_robin_arbiter (
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] granted
);
    reg [1:0] current_priority;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            granted <= 4'b0000;
            current_priority <= 0;
        end else begin
            granted <= 4'b0000; // Default: no grants
            if (req != 4'b0000) begin
                // Grant the highest priority request
                case (current_priority)
                    2'b00: if (req[0]) granted <= 4'b0001; else if (req[1]) granted <= 4'b0010; else if (req[2]) granted <= 4'b0100; else if (req[3]) granted <= 4'b1000;
                    2'b01: if (req[1]) granted <= 4'b0010; else if (req[2]) granted <= 4'b0100; else if (req[3]) granted <= 4'b1000; else if (req[0]) granted <= 4'b0001;
                    2'b10: if (req[2]) granted <= 4'b0100; else if (req[3]) granted <= 4'b1000; else if (req[0]) granted <= 4'b0001; else if (req[1]) granted <= 4'b0010;
                    2'b11: if (req[3]) granted <= 4'b1000; else if (req[0]) granted <= 4'b0001; else if (req[1]) granted <= 4'b0010; else if (req[2]) granted <= 4'b0100;
                endcase

                // Advance the current priority
                current_priority <= (current_priority + 1) % 4;
            end
        end
    end
endmodule