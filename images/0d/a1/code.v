module hamming_encoder(  
    input [3:0] data,  
    output [6:0] code  
);  
    wire p1, p2, p3;  
    assign p1 = data[0] ^ data[1] ^ data[3]; // parity bit 1  
    assign p2 = data[0] ^ data[2] ^ data[3]; // parity bit 2  
    assign p3 = data[1] ^ data[2] ^ data[3]; // parity bit 3  

    assign code[6] = data[0];  
    assign code[5] = data[1];  
    assign code[4] = data[2];  
    assign code[3] = p1;  
    assign code[2] = p2;  
    assign code[1] = data[3];  
    assign code[0] = p3;  
endmodule