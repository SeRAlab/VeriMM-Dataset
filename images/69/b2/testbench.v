`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] SW;
    wire [6:0] HEX0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .HEX0(HEX0)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Input SW=00 (Digit 0)", test_num);
        SW = 10'b0000000000;
        #10;
        #1;

        check_outputs(7'h40);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Input SW=01 (Digit 1)", test_num);
        SW = 10'b0000000001;
        #10;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Input SW=10 (Digit 2)", test_num);
        SW = 10'b0000000010;
        #10;
        #1;

        check_outputs(7'h24);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Input SW=11 (Digit 3)", test_num);
        SW = 10'b0000000011;
        #10;
        #1;

        check_outputs(7'h30);
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
        input [6:0] expected_HEX0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HEX0 === (expected_HEX0 ^ HEX0 ^ expected_HEX0)) begin
                $display("PASS");
                $display("  Outputs: HEX0=%h",
                         HEX0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX0=%h",
                         expected_HEX0);
                $display("  Got:      HEX0=%h",
                         HEX0);
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
