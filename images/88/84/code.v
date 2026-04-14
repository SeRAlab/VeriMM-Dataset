module top_module(
    input clk, en, reset, load,
    input [3:0] data_in,
    output [3:0] data_out,
    output reg carry_out  // Change carry_out to reg type
);reg [3:0] counter;

    always @ (posedge clk or negedge reset) begin
        if (!reset) begin
            counter <= 4'b0000;
            carry_out <= 1'b0;
        end else if (load) begin
            counter <= data_in;
            carry_out <= 1'b0;
        end else if (en) begin
            if (counter == 4'b1111) begin
                counter <= 4'b0000;
                carry_out <= 1'b1;
            end else begin
                counter <= counter + 1;
                carry_out <= 1'b0;
            end
        end else begin
            carry_out <= 1'b0;
        end
    end

    assign data_out = counter;

endmodule