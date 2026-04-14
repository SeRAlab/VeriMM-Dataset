module edge_counter(
    input               clk         ,   
    input               rst         ,
    input               sig_in      ,
 
    output  reg [7:0]   count_out
);

    reg sig_in_d;

    // Detect rising edge
    wire rising_edge = sig_in & ~sig_in_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count_out <= 0;
            sig_in_d <= 0;
        end
        else begin
            sig_in_d <= sig_in;
            if (rising_edge)
                count_out <= count_out + 1;
        end
    end

endmodule