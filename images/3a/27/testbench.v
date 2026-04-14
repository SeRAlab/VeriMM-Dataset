`timescale 1ns/1ps

module k_means_clustering_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x;
    reg [4:0] y;
    wire [1:0] centroid_index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    k_means_clustering dut (
        .x(x),
        .y(y),
        .centroid_index(centroid_index)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Point at (5, 5)");
        x = 5'd5;
        y = 5'd5;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Point at (28, 2)");
        x = 5'd28;
        y = 5'd2;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Point at (4, 30)");
        x = 5'd4;
        y = 5'd30;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Point at (30, 30)");
        x = 5'd30;
        y = 5'd30;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Midpoint (15, 5)");
        x = 5'd15;
        y = 5'd5;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Boundary (16, 5)");
        x = 5'd16;
        y = 5'd5;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Origin (0, 0)");
        x = 5'd0;
        y = 5'd0;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Corner (31, 31)");
        x = 5'd31;
        y = 5'd31;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Dead center (15, 15)");
        x = 5'd15;
        y = 5'd15;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Midpoint (25, 15)");
        x = 5'd25;
        y = 5'd15;
        #1;

        check_outputs(2'd1);
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
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_centroid_index;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_centroid_index === (expected_centroid_index ^ centroid_index ^ expected_centroid_index)) begin
                $display("PASS");
                $display("  Outputs: centroid_index=%h",
                         centroid_index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroid_index=%h",
                         expected_centroid_index);
                $display("  Got:      centroid_index=%h",
                         centroid_index);
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
