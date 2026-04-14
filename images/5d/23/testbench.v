`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg DigitalLDir;
    reg DigitalRDir;
    reg reset_n;
    wire [3:0] outputs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DigitalLDir(DigitalLDir),
        .DigitalRDir(DigitalRDir),
        .reset_n(reset_n),
        .outputs(outputs)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %03d: Reset Active Low Verification", test_num);

        reset_n = 0;
        DigitalLDir = 1;
        DigitalRDir = 1;
        #10;

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %03d: Both Wheels Forward (L=1, R=1)", test_num);
        reset_n = 0; #5; reset_n = 1;
        DigitalLDir = 1;
        DigitalRDir = 1;
        #10;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %03d: Only Left Wheel Forward (L=1, R=0)", test_num);
        reset_n = 0; #5; reset_n = 1;
        DigitalLDir = 1;
        DigitalRDir = 0;
        #10;

        #1;


        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %03d: Only Right Wheel Forward (L=0, R=1)", test_num);
        reset_n = 0; #5; reset_n = 1;
        DigitalLDir = 0;
        DigitalRDir = 1;
        #10;

        #1;


        check_outputs(4'b0101);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %03d: Default Condition (L=0, R=0)", test_num);
        reset_n = 0; #5; reset_n = 1;
        DigitalLDir = 0;
        DigitalRDir = 0;
        #10;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_outputs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outputs === (expected_outputs ^ outputs ^ expected_outputs)) begin
                $display("PASS");
                $display("  Outputs: outputs=%h",
                         outputs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputs=%h",
                         expected_outputs);
                $display("  Got:      outputs=%h",
                         outputs);
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
