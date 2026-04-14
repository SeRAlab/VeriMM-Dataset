module top_module(
    input CLK,
    input reset,
    output reg CLK_div
);reg [3:0] counter;

    always @ (posedge CLK or posedge reset) begin
        if (reset) begin
            counter <= 0;
            CLK_div <= 0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 4) begin
                counter <= 0;
                CLK_div <= ~CLK_div;
            end
        end
    end

endmodule