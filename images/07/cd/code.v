module MemoryAllocator(  
    input wire clk,  
    input wire rst,  
    input wire [3:0] alloc_size, // size to allocate (in bytes)  
    input wire alloc_req, // allocation request signal  
    input wire free_req, // free request signal  
    output reg [3:0] status // allocation status: 0 = success, 1 = fail  
);  

    reg [7:0] memory [0:15]; // 16 bytes of memory  
    reg [3:0] used; // number of bytes currently allocated  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            used <= 4'd0;  
            status <= 4'd0;  
        end else begin  
            if (alloc_req) begin  
                if (used + alloc_size <= 16) begin  
                    used <= used + alloc_size;  
                    status <= 4'd0; // success  
                end else begin  
                    status <= 4'd1; // fail  
                end  
            end  
            if (free_req) begin  
                if (used >= alloc_size) begin  
                    used <= used - alloc_size;  
                    status <= 4'd0; // success  
                end else begin  
                    status <= 4'd1; // fail  
                end  
            end  
        end  
    end  
endmodule