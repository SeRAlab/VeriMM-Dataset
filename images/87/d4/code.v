module top_module(
    input clk,
    input rst,
    input step,
    output reg [2:0] signal
);reg [2:0] intensity = 0;
    reg direction = 0;
    reg state = 0;

    always @ (posedge clk) begin
        if (rst) begin
            intensity <= 0;
            direction <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (step) state <= 1;
                end
                1: begin
                    case (direction)
                        0: begin
                            if (step) begin
                                intensity <= intensity + 1;
                                if (intensity == 3'b110) direction <= 1;
                            end
                        end
                        1: begin
                            if (step) begin
                                intensity <= intensity - 1;
                                if (intensity == 3'b001) begin
                                    direction <= 0;
                                    state <= 0;
                                end
                            end
                        end
                    endcase
                end
            endcase
        end
    end

    assign signal = intensity;
endmodule