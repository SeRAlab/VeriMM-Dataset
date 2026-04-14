module round_robin_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] req,
    output reg [3:0] gnt
);
    reg [1:0] last_grant;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gnt <= 4'b0000;
            last_grant <= 2'b00;
        end else begin
            case (last_grant)
                2'b00: begin
                    if (req[0]) gnt <= 4'b0001;
                    else if (req[1]) gnt <= 4'b0010;
                    else if (req[2]) gnt <= 4'b0100;
                    else if (req[3]) gnt <= 4'b1000;
                end
                2'b01: begin
                    if (req[1]) gnt <= 4'b0010;
                    else if (req[2]) gnt <= 4'b0100;
                    else if (req[3]) gnt <= 4'b1000;
                    else if (req[0]) gnt <= 4'b0001;
                end
                2'b10: begin
                    if (req[2]) gnt <= 4'b0100;
                    else if (req[3]) gnt <= 4'b1000;
                    else if (req[0]) gnt <= 4'b0001;
                    else if (req[1]) gnt <= 4'b0010;
                end
                2'b11: begin
                    if (req[3]) gnt <= 4'b1000;
                    else if (req[0]) gnt <= 4'b0001;
                    else if (req[1]) gnt <= 4'b0010;
                    else if (req[2]) gnt <= 4'b0100;
                end
            endcase
            last_grant <= gnt ? (last_grant + 1) : last_grant; // Update last_grant if gnt is not zero
        end
    end
endmodule