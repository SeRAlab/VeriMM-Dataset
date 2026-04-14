`timescale 1ns/1ps

module kmeans_clustering_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] cx1;
    reg [7:0] cx2;
    reg [7:0] cy1;
    reg [7:0] cy2;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire [1:0] cluster1;
    wire [1:0] cluster2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_clustering dut (
        .cx1(cx1),
        .cx2(cx2),
        .cy1(cy1),
        .cy2(cy2),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .cluster1(cluster1),
        .cluster2(cluster2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Points exactly at centroids", test_num);
            cx1 = 8'd10; cy1 = 8'd10;
            cx2 = 8'd100; cy2 = 8'd100;
            x1 = 8'd10;  y1 = 8'd10;
            x2 = 8'd100; y2 = 8'd100;
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Points close to centroids", test_num);
            cx1 = 8'd50; cy1 = 8'd50;
            cx2 = 8'd200; cy2 = 8'd200;
            x1 = 8'd55;  y1 = 8'd45;
            x2 = 8'd190; y2 = 8'd210;
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reversed point assignment", test_num);
            cx1 = 8'd20;  cy1 = 8'd20;
            cx2 = 8'd220; cy2 = 8'd220;
            x1 = 8'd230; y1 = 8'd230;
            x2 = 8'd15;  y2 = 8'd15;
            #1;

            check_outputs(2'd1, 2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equidistant point and slight shift", test_num);
            cx1 = 8'd0;   cy1 = 8'd0;
            cx2 = 8'd100; cy2 = 8'd0;
            x1 = 8'd50;  y1 = 8'd0;
            x2 = 8'd51;  y2 = 8'd0;
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large coordinate values (8-bit max range)", test_num);
            cx1 = 8'd255; cy1 = 8'd255;
            cx2 = 8'd0;   cy2 = 8'd0;
            x1 = 8'd250; y1 = 8'd250;
            x2 = 8'd5;   y2 = 8'd5;
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shared coordinates", test_num);
            cx1 = 8'd10;  cy1 = 8'd10;
            cx2 = 8'd10;  cy2 = 8'd200;
            x1 = 8'd10;   y1 = 8'd50;
            x2 = 8'd255;  y2 = 8'd180;
            #1;

            check_outputs(2'd0, 2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Tight grouping near origin", test_num);
            cx1 = 8'd1; cy1 = 8'd1;
            cx2 = 8'd5; cy2 = 8'd5;
            x1 = 8'd2; y1 = 8'd2;
            x2 = 8'd4; y2 = 8'd4;
            #1;

            check_outputs(2'd0, 2'd1);
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
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_cluster1;
        input [1:0] expected_cluster2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cluster1 === (expected_cluster1 ^ cluster1 ^ expected_cluster1) &&
                expected_cluster2 === (expected_cluster2 ^ cluster2 ^ expected_cluster2)) begin
                $display("PASS");
                $display("  Outputs: cluster1=%h, cluster2=%h",
                         cluster1, cluster2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cluster1=%h, cluster2=%h",
                         expected_cluster1, expected_cluster2);
                $display("  Got:      cluster1=%h, cluster2=%h",
                         cluster1, cluster2);
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

endmodule
