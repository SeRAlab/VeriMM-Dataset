`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg w;
    reg [1:0] y;
    wire Y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w(w),
        .y(y),
        .Y1(Y1)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Current State X (00), w = 0 -> Expect Next y[1] = 1", test_num);
        y = 2'b00;
        w = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Current State X (00), w = 1 -> Expect Next y[1] = 0", test_num);
        y = 2'b00;
        w = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Current State Y (01), w = 0 -> Expect Next y[1] = 0", test_num);
        y = 2'b01;
        w = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Current State Y (01), w = 1 -> Expect Next y[1] = 0", test_num);
        y = 2'b01;
        w = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Current State Z (10), w = 0 -> Expect Next y[1] = 0", test_num);
        y = 2'b10;
        w = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Current State Z (10), w = 1 -> Expect Next y[1] = 1", test_num);
        y = 2'b10;
        w = 1'b1;
        #1;

        check_outputs(1'b1);
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
        input expected_Y1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1)) begin
                $display("PASS");
                $display("  Outputs: Y1=%b",
                         Y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y1=%b",
                         expected_Y1);
                $display("  Got:      Y1=%b",
                         Y1);
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
