`timescale 1ns/1ps

module quicksort_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] arr;
    wire [15:0] sorted_arr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quicksort dut (
        .arr(arr),
        .sorted_arr(sorted_arr)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Already Sorted Array", test_num);
            arr = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reverse Sorted Array", test_num);
            arr = 16'h4321;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Mixed Order", test_num);
            arr = 16'h7A25;
            #1;

            check_outputs(16'h257A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Array with Duplicates", test_num);
            arr = 16'h3B31;
            #1;

            check_outputs(16'h133B);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: All Elements Identical", test_num);
            arr = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Extreme Values (Min/Max)", test_num);
            arr = 16'hF00F;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Single Element Different", test_num);
            arr = 16'h8828;
            #1;

            check_outputs(16'h2888);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Pivot selection edge case", test_num);
            arr = 16'h1E2D;
            #1;

            check_outputs(16'h12ED);
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
        input [15:0] expected_sorted_arr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted_arr === (expected_sorted_arr ^ sorted_arr ^ expected_sorted_arr)) begin
                $display("PASS");
                $display("  Outputs: sorted_arr=%h",
                         sorted_arr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted_arr=%h",
                         expected_sorted_arr);
                $display("  Got:      sorted_arr=%h",
                         sorted_arr);
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
