module ring_counter(
    input       clk,
    input       rst,
    output reg [5:0] count
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            count <= 6'b000001;
        end
        else begin
            count <= {count[4:0], count[5]};
        end
    end

endmodule