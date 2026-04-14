`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [32:0] din;
    reg incr;
    wire [32:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .incr(incr),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero input, No increment", test_num);
        din = 33'h000000000;
        incr = 1'b0;
        #1;

        check_outputs(33'h000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero input, With increment", test_num);
        din = 33'h000000000;
        incr = 1'b1;
        #1;

        check_outputs(33'h000000001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum 33rd bit, No increment", test_num);
        din = 33'h100000000;
        incr = 1'b0;
        #1;

        check_outputs(33'h100000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum 33rd bit, With increment", test_num);
        din = 33'h100000000;
        incr = 1'b1;
        #1;

        check_outputs(33'h100000001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lower 32 bits full, Trigger carry to 33rd bit", test_num);
        din = 33'h0FFFFFFFF;
        incr = 1'b1;
        #1;

        check_outputs(33'h100000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits set, Increment (Overflow/Wrap-around)", test_num);
        din = 33'h1FFFFFFFF;
        incr = 1'b1;
        #1;

        check_outputs(33'h000000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits set, No increment", test_num);
        din = 33'h1FFFFFFFF;
        incr = 1'b0;
        #1;

        check_outputs(33'h1FFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern A, With increment", test_num);
        din = 33'h0AAAAAAAA;
        incr = 1'b1;
        #1;

        check_outputs(33'h0AAAAAAAB);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern 5, With increment", test_num);
        din = 33'h155555555;
        incr = 1'b1;
        #1;

        check_outputs(33'h155555556);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range carry propagation", test_num);
        din = 33'h00000FFFF;
        incr = 1'b1;
        #1;

        check_outputs(33'h000010000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [32:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
