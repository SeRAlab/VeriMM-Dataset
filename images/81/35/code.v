module top_module(
    input clk,
    input slowena,
    input reset,
    input select,
    input a, b, c,
    output reg out // Change wire to reg
);reg [3:0] counter;
    reg pause;
    wire [2:0] and_input;
    wire and_output;
    wire or_output;

    assign and_input = {a, b, c};
    assign and_output = and_input[0] & and_input[1] & and_input[2];
    assign or_output = counter[3] | and_output;

    always @(negedge clk) begin
        if (reset) begin
            counter <= 4'b0000;
            pause <= 1'b0;
        end else if (slowena) begin
            if (pause) begin
                counter <= counter;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    always @(*) begin
        if (select) begin
            out <= or_output;
        end else begin
            out <= and_output;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            pause <= 1'b0;
        end else if (slowena) begin
            if (counter == 4'b1001) begin
                pause <= 1'b1;
            end else if (pause) begin
                pause <= 1'b0;
            end
        end
    end

endmodule