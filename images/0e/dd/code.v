module KNN #(parameter N=5, parameter K=3, parameter DIM=2)(  
    input [DIM-1:0] feature_vector,  
    input [DIM*N-1:0] training_data,  
    input [N-1:0] labels,  
    output reg [3:0] predicted_class  
);  
    integer i, j;  
    reg [7:0] distances [0:N-1];  
    reg [N-1:0] neighbor_classes;  
    reg [N-1:0] count;  

    always @* begin  
        // Calculate the Euclidean distances  
        for (i = 0; i < N; i = i + 1) begin  
            distances[i] = 0;  
            for (j = 0; j < DIM; j = j + 1) begin  
                distances[i] = distances[i] + (feature_vector[j] - training_data[(i * DIM) + j]) * (feature_vector[j] - training_data[(i * DIM) + j]);  
            end  
        end  

        // Sort neighbors by distance and count classes of the K nearest neighbors  
        neighbor_classes = 0;  
        count = 0;  
        for (i = 0; i < K; i = i + 1) begin  
            // Find the nearest neighbor (simplified for this example)  
            if (distances[i] < distances[count]) begin  
                count = i;  
            end  
            neighbor_classes[count] = labels[count];  
        end  

        // Determine the majority class  
        predicted_class = 0;  
        for (i = 0; i < N; i = i + 1) begin  
            if (neighbor_classes[i]) begin  
                predicted_class = predicted_class + 1;  
            end  
        end  
    end  
endmodule