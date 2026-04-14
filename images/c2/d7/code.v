module up_down_counter (
    input clk,
    input rst_n,
    input up_down,
    input [3:0] load_data,
    output reg [3:0] count
);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 4'b0000;
        end
        else begin
            if (up_down) begin
                count <= count + 1;
            end
            else begin
                count <= count - 1;
            end
            
            if (load_data != 4'b0000) begin
                count <= load_data;
            end
        end
    end

endmodule