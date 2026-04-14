`timescale 1ns/1ps

module quick_sort_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] unsorted;
    wire [19:0] sorted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quick_sort dut (
        .unsorted(unsorted),
        .sorted(sorted)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            unsorted = 20'h54321;
            $display("Test Case %0d: Reverse sorted input", test_num);
            #1;

            check_outputs(20'h12345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            unsorted = 20'h12345;
            $display("Test Case %0d: Already sorted input", test_num);
            #1;

            check_outputs(20'h12345);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            unsorted = 20'h77777;
            $display("Test Case %0d: All identical values", test_num);
            #1;

            check_outputs(20'h77777);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            unsorted = 20'h31415;
            $display("Test Case %0d: Input with duplicates", test_num);
            #1;

            check_outputs(20'h11345);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            unsorted = 20'hF0A52;
            $display("Test Case %0d: Mixed random values", test_num);
            #1;

            check_outputs(20'h025AF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            unsorted = 20'h0000F;
            $display("Test Case %0d: Single max value at end", test_num);
            #1;

            check_outputs(20'h0000F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            unsorted = 20'hF0000;
            $display("Test Case %0d: Single max value at start", test_num);
            #1;

            check_outputs(20'h0000F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            unsorted = 20'h92A1E;
            $display("Test Case %0d: Random hexadecimal spread", test_num);
            #1;

            check_outputs(20'h129AE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            unsorted = 20'hABCDE;
            $display("Test Case %0d: Already sorted high values", test_num);
            #1;

            check_outputs(20'hABCDE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            unsorted = 20'h28282;
            $display("Test Case %0d: Alternating duplicates", test_num);
            #1;

            check_outputs(20'h22288);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quick_sort Testbench");
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
