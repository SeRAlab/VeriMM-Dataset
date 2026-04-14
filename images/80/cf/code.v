module top_module(
    input clk, 
    input reset,
    input quadA, 
    input quadB, 
    output reg [7:0] count
);reg [2:0] quadA_delayed;
    reg [2:0] quadB_delayed;
    wire count_enable = quadA_delayed[1] ^ quadA_delayed[2] ^ quadB_delayed[1] ^ quadB_delayed[2];
    wire count_direction = quadA_delayed[1] ^ quadB_delayed[2];

    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            quadA_delayed <= 0;
        end else begin
            quadA_delayed <= {quadA_delayed[1:0], quadA};
        end
    end
    
    always @(posedge clk or posedge reset) begin 
        if (reset) begin 
            quadB_delayed <= 0;
        end else begin
            quadB_delayed <= {quadB_delayed[1:0], quadB};
        end
    end

    reg [31:0] total;
    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            total <= 0;
            count <= 0;
        end else if(count_enable) begin
            if(count_direction) total <= total+1; 
            else total <= total-1;
            count <= total[7:0];
        end
    end
endmodule