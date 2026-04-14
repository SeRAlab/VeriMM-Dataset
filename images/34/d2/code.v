module round_robin_arbiter (
    input clk,
    input rst,
    input [3:0] req,
    output reg [3:0] grant
);
    reg [1:0] state;  // 2-bit state to represent the last granted requestor

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;  // start with G0
            grant <= 4'b0001;  // grant G0
        end else begin
            // Check for requests starting from the next requestor
            case (state)
                2'b00: begin
                    if (req[0]) begin
                        grant <= 4'b0001;  // grant G0
                    end else if (req[1]) begin
                        grant <= 4'b0010;  // grant G1
                        state <= 2'b01;
                    end else if (req[2]) begin
                        grant <= 4'b0100;  // grant G2
                        state <= 2'b10;
                    end else if (req[3]) begin
                        grant <= 4'b1000;  // grant G3
                        state <= 2'b11;
                    end else begin
                        grant <= 4'b0000;  // no grant
                    end
                end
                2'b01: begin
                    if (req[1]) begin
                        grant <= 4'b0010;  // grant G1
                    end else if (req[2]) begin
                        grant <= 4'b0100;  // grant G2
                        state <= 2'b10;
                    end else if (req[3]) begin
                        grant <= 4'b1000;  // grant G3
                        state <= 2'b11;
                    end else if (req[0]) begin
                        grant <= 4'b0001;  // grant G0
                        state <= 2'b00;
                    end else begin
                        grant <= 4'b0000;  // no grant
                    end
                end
                2'b10: begin
                    if (req[2]) begin
                        grant <= 4'b0100;  // grant G2
                    end else if (req[3]) begin
                        grant <= 4'b1000;  // grant G3
                        state <= 2'b11;
                    end else if (req[0]) begin
                        grant <= 4'b0001;  // grant G0
                        state <= 2'b00;
                    end else if (req[1]) begin
                        grant <= 4'b0010;  // grant G1
                        state <= 2'b01;
                    end else begin
                        grant <= 4'b0000;  // no grant
                    end
                end
                2'b11: begin
                    if (req[3]) begin
                        grant <= 4'b1000;  // grant G3
                    end else if (req[0]) begin
                        grant <= 4'b0001;  // grant G0
                        state <= 2'b00;
                    end else if (req[1]) begin
                        grant <= 4'b0010;  // grant G1
                        state <= 2'b01;
                    end else if (req[2]) begin
                        grant <= 4'b0100;  // grant G2
                        state <= 2'b10;
                    end else begin
                        grant <= 4'b0000;  // no grant
                    end
                end
            endcase
        end
    end
endmodule