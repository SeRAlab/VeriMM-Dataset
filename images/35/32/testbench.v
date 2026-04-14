`timescale 1ns/1ps

module quick_sort_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] array;
    wire [15:0] sorted_array;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quick_sort dut (
        .array(array),
        .sorted_array(sorted_array)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Already Sorted Array", test_num);
            array = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Reverse Sorted Array", test_num);
            array = 16'h4321;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Max and Min Values", test_num);
            array = 16'hF0A5;
            #1;

            check_outputs(16'h05AF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: All Identical Elements", test_num);
            array = 16'h8888;
            #1;

            check_outputs(16'h8888);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Duplicate Values", test_num);
            array = 16'h2E21;
            #1;

            check_outputs(16'h122E);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Random Permutation", test_num);
            array = 16'hCBDA;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Mixed High/Low Values", test_num);
            array = 16'h0F0F;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Single Value Displacement", test_num);
            array = 16'h2341;
            #1;

            check_outputs(16'h1234);
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
        input [15:0] expected_sorted_array;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sorted_array === (expected_sorted_array ^ sorted_array ^ expected_sorted_array)) begin
                $display("PASS");
                $display("  Outputs: sorted_array=%h",
                         sorted_array);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sorted_array=%h",
                         expected_sorted_array);
                $display("  Got:      sorted_array=%h",
                         sorted_array);
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
