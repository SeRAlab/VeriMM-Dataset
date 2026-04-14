module edge_counter(
    input        clk,
    input        rst_n,
    input        signal_in,
    output reg [7:0] edge_count
);

    reg signal_in_d;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            signal_in_d <= 1'b0;
            edge_count <= 8'b0;
        end
        else begin
            signal_in_d <= signal_in;
            if(signal_in & ~signal_in_d)
                edge_count <= edge_count + 1;
        end
    end

endmodule