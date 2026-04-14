module fixed_priority_arbiter (
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] last_granted;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            last_granted <= 2'b00;
        end else begin
            case (req)
                4'b1000: begin grant <= 4'b1000; last_granted <= 2'b00; end
                4'b0100: begin grant <= 4'b0100; last_granted <= 2'b01; end
                4'b0010: begin grant <= 4'b0010; last_granted <= 2'b10; end
                4'b0001: begin grant <= 4'b0001; last_granted <= 2'b11; end
                default: begin
                    case (last_granted)
                        2'b00: if (req[1]) begin grant <= 4'b0100; last_granted <= 2'b01; end
                        2'b01: if (req[2]) begin grant <= 4'b0010; last_granted <= 2'b10; end
                        2'b10: if (req[3]) begin grant <= 4'b0001; last_granted <= 2'b11; end
                        2'b11: if (req[0]) begin grant <= 4'b1000; last_granted <= 2'b00; end
                        default: grant <= 4'b0000;
                    endcase
                end
            endcase
        end
    end
endmodule