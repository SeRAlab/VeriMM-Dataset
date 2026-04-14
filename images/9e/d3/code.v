module async_reset_counter (
    input               clk,
    input               rst,
    output reg [7:0]    count
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 8'b00000000;
        end else begin
            count <= count + 1;
        end
    end
    
endmodule