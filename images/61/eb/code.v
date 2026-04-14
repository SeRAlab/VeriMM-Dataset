module top_module(
    input clk,
    input areset,
    input load,
    input up_down,
    input count_enable,
    output reg [3:0] count,
    output reg max_reached // Changed to reg
);reg [3:0] next_count;
    
    always @(posedge clk or negedge areset) begin
        if (!areset) begin
            count <= 4'b0;
            next_count <= 4'b0;
            max_reached <= 0; // Initialize max_reached on reset
        end
        else begin
            if (load) begin
                count <= next_count;
            end
            else if (count_enable) begin
                if (up_down) begin
                    if (count == 4'b1111) begin
                        next_count <= 4'b0;
                        max_reached <= 1;
                    end
                    else begin
                        next_count <= count + 1;
                        max_reached <= 0;
                    end
                end
                else begin
                    if (count == 4'b0000) begin
                        next_count <= 4'b1111;
                        max_reached <= 1;
                    end
                    else begin
                        next_count <= count - 1;
                        max_reached <= 0;
                    end
                end
            end
        end
    end
    
endmodule