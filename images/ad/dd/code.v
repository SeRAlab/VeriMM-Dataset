module sync_counter(
    input               clk         ,   
    input               rst_n       ,
    input               clk_en      ,
    output  reg [3:0]   count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else if (clk_en) begin
            if (count == 4'b1111) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule