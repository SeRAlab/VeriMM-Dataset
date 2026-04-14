module edge_counter(
    input               clk         ,
    input               rst_n       ,
    input               signal_in   ,

    output  reg [15:0]  count
);

    reg signal_in_d;

    // Register the input signal to detect rising edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            signal_in_d <= 0;
        end else begin
            signal_in_d <= signal_in;
        end
    end

    // Count rising edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else if (signal_in && !signal_in_d) begin
            count <= count + 1;
        end
    end

endmodule