module reset_controller (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg reset
);

    reg [1:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            reset <= 1'b1;
            counter <= 2'b00;
        end else begin
            if (reset) begin
                if (counter < 2'b10) begin
                    counter <= counter + 1;
                end else begin
                    reset <= enable;
                end
            end else begin
                reset <= enable;
            end
        end
    end
endmodule