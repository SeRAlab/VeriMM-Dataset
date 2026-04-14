`timescale 1ns/1ps

module k_means_clustering_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] centroid0;
    reg [7:0] centroid1;
    reg [7:0] centroid2;
    reg [7:0] data_point;
    wire [2:0] nearest_cluster;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    k_means_clustering dut (
        .centroid0(centroid0),
        .centroid1(centroid1),
        .centroid2(centroid2),
        .data_point(data_point),
        .nearest_cluster(nearest_cluster)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data point closest to Centroid 0", test_num);
        centroid0 = 8'd10;
        centroid1 = 8'd100;
        centroid2 = 8'd200;
        data_point = 8'd15;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data point closest to Centroid 1", test_num);
        centroid0 = 8'd10;
        centroid1 = 8'd50;
        centroid2 = 8'd100;
        data_point = 8'd55;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data point closest to Centroid 2", test_num);
        centroid0 = 8'd10;
        centroid1 = 8'd50;
        centroid2 = 8'd100;
        data_point = 8'd250;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data point exactly matches Centroid 1", test_num);
        centroid0 = 8'd20;
        centroid1 = 8'd80;
        centroid2 = 8'd140;
        data_point = 8'd80;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Tie-breaker between Centroid 0 and 1", test_num);
        centroid0 = 8'd10;
        centroid1 = 8'd20;
        centroid2 = 8'd100;
        data_point = 8'd15;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Tie-breaker between Centroid 1 and 2", test_num);
        centroid0 = 8'd0;
        centroid1 = 8'd100;
        centroid2 = 8'd110;
        data_point = 8'd105;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values test", test_num);
        centroid0 = 8'd255;
        centroid1 = 8'd0;
        centroid2 = 8'd128;
        data_point = 8'd250;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum values test", test_num);
        centroid0 = 8'd5;
        centroid1 = 8'd10;
        centroid2 = 8'd15;
        data_point = 8'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("k_means_clustering Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_nearest_cluster;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nearest_cluster === (expected_nearest_cluster ^ nearest_cluster ^ expected_nearest_cluster)) begin
                $display("PASS");
                $display("  Outputs: nearest_cluster=%h",
                         nearest_cluster);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nearest_cluster=%h",
                         expected_nearest_cluster);
                $display("  Got:      nearest_cluster=%h",
                         nearest_cluster);
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
