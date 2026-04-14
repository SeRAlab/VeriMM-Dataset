module debouncer(
    input                 clk,
    input                 rst,
    input                 signal_in,
    input [31:0]          stable_count,
    
    output reg            signal_out
);

reg [31:0] counter;
reg signal_in_d;

// Debouncer implementation
always @(posedge clk) begin
    if (rst) begin
        signal_in_d <= 1'b0;
        counter <= 32'd0;
        signal_out <= 1'b0;
    end
    else begin
        if (signal_in == signal_in_d) begin
            if (counter < stable_count) begin
                counter <= counter + 1;
            end
            else begin
                signal_out <= signal_in;
            end
        end
        else begin
            counter <= 32'd0;
        end
        signal_in_d <= signal_in;
    end
end

endmodule