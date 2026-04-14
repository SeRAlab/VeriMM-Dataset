`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] cluster_id;
    reg [7:0] data_point;
    reg rst;
    reg valid;
    wire [7:0] centroid_0;
    wire [7:0] centroid_1;
    wire [7:0] centroid_2;
    wire [7:0] centroid_3;
    wire [7:0] centroid_4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .clk(clk),
        .cluster_id(cluster_id),
        .data_point(data_point),
        .rst(rst),
        .valid(valid),
        .centroid_0(centroid_0),
        .centroid_1(centroid_1),
        .centroid_2(centroid_2),
        .centroid_3(centroid_3),
        .centroid_4(centroid_4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            cluster_id = 0;
            data_point = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single point per cluster", test_num);
            reset_dut();


            cluster_id = 3'd0; data_point = 8'd10; valid = 1; @(posedge clk);

            cluster_id = 3'd1; data_point = 8'd20; valid = 1; @(posedge clk);

            cluster_id = 3'd2; data_point = 8'd30; valid = 1; @(posedge clk);

            cluster_id = 3'd3; data_point = 8'd40; valid = 1; @(posedge clk);

            cluster_id = 3'd4; data_point = 8'd50; valid = 1; @(posedge clk);

            valid = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'd10, 8'd20, 8'd30, 8'd40, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple points averaging", test_num);
            reset_dut();


            cluster_id = 3'd0; data_point = 8'd10; valid = 1; @(posedge clk);
            cluster_id = 3'd0; data_point = 8'd30; valid = 1; @(posedge clk);


            cluster_id = 3'd1; data_point = 8'd100; valid = 1; @(posedge clk);
            cluster_id = 3'd1; data_point = 8'd200; valid = 1; @(posedge clk);

            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd20, 8'd150, 8'd0, 8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max values and integer division", test_num);
            reset_dut();


            cluster_id = 3'd4; data_point = 8'hFF; valid = 1; @(posedge clk);
            cluster_id = 3'd4; data_point = 8'hFF; valid = 1; @(posedge clk);
            cluster_id = 3'd4; data_point = 8'hFE; valid = 1; @(posedge clk);


            cluster_id = 3'd2; data_point = 8'd5; valid = 1; @(posedge clk);
            cluster_id = 3'd2; data_point = 8'd6; valid = 1; @(posedge clk);

            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 8'd0, 8'd5, 8'd0, 8'd254);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Valid signal behavior", test_num);
            reset_dut();


            cluster_id = 3'd3; data_point = 8'd100; valid = 1; @(posedge clk);


            cluster_id = 3'd3; data_point = 8'd200; valid = 0; @(posedge clk);


            cluster_id = 3'd3; data_point = 8'd50; valid = 1; @(posedge clk);


            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 8'd0, 8'd0, 8'd75, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero values", test_num);
            reset_dut();

            cluster_id = 3'd0; data_point = 8'd0; valid = 1; @(posedge clk);
            cluster_id = 3'd0; data_point = 8'd0; valid = 1; @(posedge clk);

            valid = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'd0, 8'd0, 8'd0, 8'd0, 8'd0);
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
        input [7:0] expected_centroid_4;
        begin
            if (expected_centroid_0 === (expected_centroid_0 ^ centroid_0 ^ expected_centroid_0) &&
                expected_centroid_1 === (expected_centroid_1 ^ centroid_1 ^ expected_centroid_1) &&
                expected_centroid_2 === (expected_centroid_2 ^ centroid_2 ^ expected_centroid_2) &&
                expected_centroid_3 === (expected_centroid_3 ^ centroid_3 ^ expected_centroid_3) &&
                expected_centroid_4 === (expected_centroid_4 ^ centroid_4 ^ expected_centroid_4)) begin
                $display("PASS");
                $display("  Outputs: centroid_0=%h, centroid_1=%h, centroid_2=%h, centroid_3=%h, centroid_4=%h",
                         centroid_0, centroid_1, centroid_2, centroid_3, centroid_4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroid_0=%h, centroid_1=%h, centroid_2=%h, centroid_3=%h, centroid_4=%h",
                         expected_centroid_0, expected_centroid_1, expected_centroid_2, expected_centroid_3, expected_centroid_4);
                $display("  Got:      centroid_0=%h, centroid_1=%h, centroid_2=%h, centroid_3=%h, centroid_4=%h",
                         centroid_0, centroid_1, centroid_2, centroid_3, centroid_4);
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
        $dumpvars(0,clk, cluster_id, data_point, rst, valid, centroid_0, centroid_1, centroid_2, centroid_3, centroid_4);
    end

endmodule
