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
        test_num = test_num + 1;
        $display("\nTest Case %0d: Already Sorted", test_num);
        unsorted = 16'h1234;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Reverse Sorted", test_num);
        unsorted = 16'h4321;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Random Order 1", test_num);
        unsorted = 16'h3142;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Identical", test_num);
        unsorted = 16'h7777;
        #1;

        check_outputs(16'h7777);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Duplicate Values", test_num);
        unsorted = 16'h2521;
        #1;

        check_outputs(16'h1225);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Max and Min Hex", test_num);
        unsorted = 16'hF0A5;
        #1;

        check_outputs(16'h05AF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Random Order 2", test_num);
        unsorted = 16'hCE18;
        #1;

        check_outputs(16'h18CE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiple Zeros", test_num);
        unsorted = 16'h0010;
        #1;

        check_outputs(16'h0001);
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
