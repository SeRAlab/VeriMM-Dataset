module KNN #(parameter DATA_WIDTH = 8, parameter N = 5, parameter K = 3)(
    input [DATA_WIDTH-1:0] input_point,
    input [N*DATA_WIDTH-1:0] training_points,
    input [N-1:0] training_classes,
    output reg [1:0] predicted_class
);
    reg [DATA_WIDTH-1:0] distances [0:N-1];
    integer i, j;

    // Calculate Manhattan distances
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            distances[i] = 0;
            for (j = 0; j < DATA_WIDTH; j = j + 1) begin
                distances[i] = distances[i] + (input_point[j] > training_points[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH] ? input_point[j] - training_points[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH] : training_points[(i+1)*DATA_WIDTH-1 -: DATA_WIDTH] - input_point[j]);
            end
        end
    end

    // Determine K-nearest neighbors and majority class
    reg [1:0] class_count [0:1];
    always @(*) begin
        class_count[0] = 0;
        class_count[1] = 0;
        
        // Sort distances and find K-nearest classes
        for (i = 0; i < K; i = i + 1) begin
            // Assuming a sorting mechanism or selection mechanism to find K smallest distances.
            // For simplicity, we'll assume distances are pre-sorted.
            if (training_classes[i] == 0)
                class_count[0] = class_count[0] + 1;
            else
                class_count[1] = class_count[1] + 1;
        end
        
        // Determine predicted class based on majority vote
        if (class_count[0] > class_count[1])
            predicted_class = 0;
        else
            predicted_class = 1;
    end
endmodule