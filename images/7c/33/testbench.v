`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] one_hot;
    wire [1:0] binary;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .one_hot(one_hot),
        .binary(binary)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input 3'b001 (Bit 0 set)", test_num);
        one_hot = 3'b001;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input 3'b010 (Bit 1 set)", test_num);
        one_hot = 3'b010;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input 3'b100 (Bit 2 set)", test_num);
        one_hot = 3'b100;
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_binary;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary === (expected_binary ^ binary ^ expected_binary)) begin
                $display("PASS");
                $display("  Outputs: binary=%h",
                         binary);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary=%h",
                         expected_binary);
                $display("  Got:      binary=%h",
                         binary);
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
