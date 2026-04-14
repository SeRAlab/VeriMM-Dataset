module debounce #(
    parameter DEBOUNCE_TIME = 100_000
) (
    input wire clk,
    input wire rst,
    input wire button_in,
    output reg button_out
);

    reg [31:0] counter;
    reg button_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 32'd0;
            button_state <= 1'b0;
            button_out <= 1'b0;
        end else begin
            if (button_in == button_state) begin
                if (counter < DEBOUNCE_TIME) begin
                    counter <= counter + 1'b1;
                end else begin
                    button_out <= button_state;
                end
            end else begin
                counter <= 32'd0;
                button_state <= button_in;
            end
        end
    end

endmodule