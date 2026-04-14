module frequency_divider (
    input clk,
    input reset,
    input [1:0] control,
    output reg divided_clk
);
    reg [2:0] counter; // Maximum 8 counts for division by 8

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            divided_clk <= 0;
        end else begin
            case (control)
                2'b00: begin // Divide by 2
                    if (counter == 1) begin
                        divided_clk <= ~divided_clk;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                2'b01: begin // Divide by 4
                    if (counter == 3) begin
                        divided_clk <= ~divided_clk;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                2'b10: begin // Divide by 8
                    if (counter == 7) begin
                        divided_clk <= ~divided_clk;
                        counter <= 0;
                    end else begin
                        counter <= counter + 1;
                    end
                end
                default: counter <= 0; // For safety, reset counter
            endcase
        end
    end
endmodule