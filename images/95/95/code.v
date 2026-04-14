module elevator (
    input clk,
    input areset,
    input up,
    input down,
    output reg [1:0] floor);

    parameter FLOOR1 = 2'b00, FLOOR2 = 2'b01, FLOOR3 = 2'b10;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            floor <= FLOOR1;
        end else begin
            case (floor)
                FLOOR1: begin
                    if (up && !down) floor <= FLOOR2;
                    else floor <= FLOOR1;
                end
                FLOOR2: begin
                    if (up && !down) floor <= FLOOR3;
                    else if (down && !up) floor <= FLOOR1;
                    else floor <= FLOOR2;
                end
                FLOOR3: begin
                    if (down && !up) floor <= FLOOR2;
                    else floor <= FLOOR3;
                end
            endcase
        end
    end
endmodule