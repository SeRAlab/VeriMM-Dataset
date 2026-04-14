module shift_register(  
    input wire clk,  
    input wire load,  
    input wire dir,  
    input wire [3:0] parallel_in,  
    output reg [3:0] q  
);  

always @(posedge clk) begin  
    if (load) begin  
        q <= parallel_in;  
    end else begin  
        if (dir) begin  
            q <= {1'b0, q[3:1]}; // Right shift  
        end else begin  
            q <= {q[2:0], 1'b0}; // Left shift  
        end  
    end  
end  
endmodule