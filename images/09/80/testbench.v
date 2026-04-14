`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_point;
    reg reset;
    reg valid_data;
    wire [7:0] centroid_0;
    wire [7:0] centroid_1;
    wire [7:0] centroid_2;
    wire [7:0] centroid_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .clk(clk),
        .data_point(data_point),
        .reset(reset),
        .valid_data(valid_data),
        .centroid_0(centroid_0),
        .centroid_1(centroid_1),
        .centroid_2(centroid_2),
        .centroid_3(centroid_3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_point = 0;
            valid_data = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase %0d: Single Data Point Assignment", test_num + 1);
            reset_dut();

            data_point = 8'd20;
            valid_data = 1;
            @(posedge clk);
            valid_data = 0;
            repeat(2) @(posedge clk);



            #1;




            check_outputs(8'd20, 8'h40, 8'h80, 8'hC0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase %0d: Mean Calculation (10, 30)", test_num + 1);
            reset_dut();


            data_point = 8'd10;
            valid_data = 1;
            @(posedge clk);

            data_point = 8'd30;
            @(posedge clk);
            valid_data = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd20, 8'h40, 8'h80, 8'hC0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase %0d: Multiple Cluster Assignment", test_num + 1);
            reset_dut();


            data_point = 8'd5;
            valid_data = 1;
            @(posedge clk);


            data_point = 8'd70;
            @(posedge clk);


            data_point = 8'd200;
            @(posedge clk);

            valid_data = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd5, 8'd70, 8'h80, 8'd200);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase %0d: All Clusters Multi-point Update", test_num + 1);
            reset_dut();


            data_point = 8'd10; valid_data = 1; @(posedge clk);
            data_point = 8'd20; @(posedge clk);


            data_point = 8'd60; @(posedge clk);
            data_point = 8'd80; @(posedge clk);


            data_point = 8'd120; @(posedge clk);
            data_point = 8'd140; @(posedge clk);


            data_point = 8'd200; @(posedge clk);
            data_point = 8'd220; @(posedge clk);

            valid_data = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd15, 8'd70, 8'd130, 8'd210);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase %0d: Boundary Values (0 and 255)", test_num + 1);
            reset_dut();

            data_point = 8'd0;
            valid_data = 1;
            @(posedge clk);

            data_point = 8'd255;
            @(posedge clk);

            valid_data = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'd0, 8'h40, 8'h80, 8'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kmeans_clustering Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_centroid_0;
        input [7:0] expected_centroid_1;
        input [7:0] expected_centroid_2;
        input [7:0] expected_centroid_3;
        begin
            if (expected_centroid_0 === (expected_centroid_0 ^ centroid_0 ^ expected_centroid_0) &&
                expected_centroid_1 === (expected_centroid_1 ^ centroid_1 ^ expected_centroid_1) &&
                expected_centroid_2 === (expected_centroid_2 ^ centroid_2 ^ expected_centroid_2) &&
                expected_centroid_3 === (expected_centroid_3 ^ centroid_3 ^ expected_centroid_3)) begin
                $display("PASS");
                $display("  Outputs: centroid_0=%h, centroid_1=%h, centroid_2=%h, centroid_3=%h",
                         centroid_0, centroid_1, centroid_2, centroid_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroid_0=%h, centroid_1=%h, centroid_2=%h, centroid_3=%h",
                         expected_centroid_0, expected_centroid_1, expected_centroid_2, expected_centroid_3);
                $display("  Got:      centroid_0=%h, centroid_1=%h, centroid_2=%h, centroid_3=%h",
                         centroid_0, centroid_1, centroid_2, centroid_3);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_point, reset, valid_data, centroid_0, centroid_1, centroid_2, centroid_3);
    end

endmodule
