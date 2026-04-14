`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] unsorted;
    wire [19:0] sorted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .unsorted(unsorted),
        .sorted(sorted)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case 001: Reverse Sorted Input");
        unsorted = 20'h54321;
        #1;

        check_outputs(20'h12345);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case 002: Already Sorted Input");
        unsorted = 20'h12345;
        #1;

        check_outputs(20'h12345);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case 003: Random Values Mix");
        unsorted = 20'hA3F07;
        #1;

        check_outputs(20'h037AF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case 004: Duplicate Values");
        unsorted = 20'h29291;
        #1;

        check_outputs(20'h12299);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case 005: All Zeros");
        unsorted = 20'h00000;
        #1;

        check_outputs(20'h00000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case 006: All Fs (Maximum Values)");
        unsorted = 20'hFFFFF;
        #1;

        check_outputs(20'hFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case 007: Scrambled with Extremes");
        unsorted = 20'h8E2B4;
        #1;

        check_outputs(20'h248BE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case 008: Single Outlier at End");
        unsorted = 20'h98760;
        #1;

        check_outputs(20'h06789);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case 009: Two Pairs and a Single");
        unsorted = 20'hAACCD;
        #1;

        check_outputs(20'hAACCD);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case 010: Alternating High/Low");
        unsorted = 20'hF0E1D;
        #1;

        check_outputs(20'h01DEF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bubble_sort Testbench");
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
        input [19:0] expected_sorted;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted === (expected_sorted ^ sorted ^ expected_sorted)) begin
                $display("PASS");
                $display("  Outputs: sorted=%h",
                         sorted);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted=%h",
                         expected_sorted);
                $display("  Got:      sorted=%h",
                         sorted);
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
