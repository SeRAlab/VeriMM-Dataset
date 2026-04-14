module IFFT_4point (  
    input [3:0] Xr0, Xr1, Xr2, Xr3, // Real parts of input  
    input [3:0] Xi0, Xi1, Xi2, Xi3, // Imaginary parts of input  
    output reg [3:0] Yr0, Yr1, Yr2, Yr3, // Real parts of output  
    output reg [3:0] Yi0, Yi1, Yi2, Yi3  // Imaginary parts of output  
);  
    always @(*) begin  
        // IFFT calculations based on the formula  
        Yr0 = (Xr0 + Xr1 + Xr2 + Xr3) >> 2;  
        Yi0 = (Xi0 + Xi1 + Xi2 + Xi3) >> 2;  

        Yr1 = (Xr0 + (Xr1 << 1) + (Xr2) - (Xr3 << 1)) >> 2;  
        Yi1 = (Xi0 + (Xi1 << 1) + (Xi2) - (Xi3 << 1)) >> 2;  

        Yr2 = (Xr0 - Xr1 + Xr2 - Xr3) >> 2;  
        Yi2 = (Xi0 - Xi1 + Xi2 - Xi3) >> 2;  

        Yr3 = (Xr0 - (Xr1 << 1) + (Xr2) + (Xr3 << 1)) >> 2;  
        Yi3 = (Xi0 - (Xi1 << 1) + (Xi2) + (Xi3 << 1)) >> 2;  
    end  
endmodule