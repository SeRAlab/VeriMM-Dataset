`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Din;
    reg En;
    wire [3:0] Do;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din(Din),
        .En(En),
        .Do(Do)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low, Input 00 -> Expected High Impedance", test_num);
            En = 1'b0;
            Din = 2'b00;
            #1;

            check_outputs(4'bzzzz);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low, Input 11 -> Expected High Impedance", test_num);
            En = 1'b0;
            Din = 2'b11;
            #1;

            check_outputs(4'bzzzz);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Din = 00 -> Expected Do = 0001", test_num);
            En = 1'b1;
            Din = 2'b00;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Din = 01 -> Expected Do = 0010", test_num);
            En = 1'b1;
            Din = 2'b01;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Din = 10 -> Expected Do = 0100", test_num);
            En = 1'b1;
            Din = 2'b10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable high, Din = 11 -> Expected Do = 1000", test_num);
            En = 1'b1;
            Din = 2'b11;
            #1;

            check_outputs(4'b1000);
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
        input [3:0] expected_Do;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Do === (expected_Do ^ Do ^ expected_Do)) begin
                $display("PASS");
                $display("  Outputs: Do=%h",
                         Do);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Do=%h",
                         expected_Do);
                $display("  Got:      Do=%h",
                         Do);
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
