`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_val;
    wire [15:0] bcd_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_val(input_val),
        .bcd_val(bcd_val)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'd0 (Minimum Valid)", test_num);
        input_val = 4'd0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'd5 (Mid Valid)", test_num);
        input_val = 4'd5;
        #1;

        check_outputs(16'h0005);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'd9 (Maximum Valid)", test_num);
        input_val = 4'd9;
        #1;

        check_outputs(16'h0009);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'd10 (Invalid Boundary)", test_num);
        input_val = 4'd10;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input 4'd15 (Max Input Value)", test_num);
        input_val = 4'd15;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_bcd_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_val === (expected_bcd_val ^ bcd_val ^ expected_bcd_val)) begin
                $display("PASS");
                $display("  Outputs: bcd_val=%h",
                         bcd_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_val=%h",
                         expected_bcd_val);
                $display("  Got:      bcd_val=%h",
                         bcd_val);
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
