module top_module(
    input CLK,
    input RST,
    input START,
    input [15:0] DURATION,
    output reg PULSE
);reg [15:0] count;

always @(posedge CLK) begin
    if (RST) begin
        count <= 0;
        PULSE <= 0;
    end
    else if (START) begin
        if (count < DURATION) begin
            count <= count + 1;
            PULSE <= 1;
        end
        else begin
            count <= 0;
            PULSE <= 0;
        end
    end
    else begin
        count <= 0;
        PULSE <= 0;
    end
end

endmodule