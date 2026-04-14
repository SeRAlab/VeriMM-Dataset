module sync_counter (
    data_in,
    load,
    reset,
    clock,
    count_out
);

    input [3:0] data_in;
    input load, reset, clock;
    output reg [3:0] count_out;

    always @(posedge clock) begin
        if (reset) begin
            count_out <= 4'b0;
        end else if (load) begin
            count_out <= data_in;
        end else begin
            count_out <= count_out + 1;
        end
    end

endmodule