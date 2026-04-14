module up_down_counter (
    input               clk,
    input               rst,
    input               ctrl,
    output reg [3:0]    count
);

    always @(posedge clk) begin
        if (rst) begin
            count <= 4'b0000;
        end else begin
            if (ctrl) begin
                count <= count + 1;
            end else begin
                count <= count - 1;
            end
        end
    end
    
endmodule