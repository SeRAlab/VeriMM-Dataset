`timescale 1ns/1ps

module quicksort_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] unsorted;
    wire [15:0] sorted;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quicksort dut (
        .unsorted(unsorted),
        .sorted(sorted)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reverse Sorted Array", test_num);
            unsorted = 16'h4321;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Already Sorted Array", test_num);
            unsorted = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All Identical Elements", test_num);
            unsorted = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Two Sets of Identical Elements", test_num);
            unsorted = 16'h5151;
            #1;

            check_outputs(16'h1155);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Array with Minimum and Maximum Values", test_num);
            unsorted = 16'hF0F0;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Random Permutation 1", test_num);
            unsorted = 16'h3142;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Random Permutation 2", test_num);
            unsorted = 16'h8A25;
            #1;

            check_outputs(16'h258A);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Single Element Out of Place (Max at Start)", test_num);
            unsorted = 16'hF123;
            #1;

            check_outputs(16'h123F);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Single Element Out of Place (Min at End)", test_num);
            unsorted = 16'hCDE1;
            #1;

            check_outputs(16'h1CDE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Complex Duplicate and Order", test_num);
            unsorted = 16'h2717;
            #1;

            check_outputs(16'h1277);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quicksort Testbench");
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
        input [15:0] expected_sorted;
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
