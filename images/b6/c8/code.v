module top_module(input CLOCK_50, output reg signal);reg [24:0] counter;

    always @(posedge CLOCK_50) begin
        counter <= counter + 1;
        if (counter == 25'd10) begin
            signal <= ~signal;
            counter <= 0;
        end
    end

endmodule