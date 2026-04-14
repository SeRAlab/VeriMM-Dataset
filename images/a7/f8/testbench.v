`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] bcdIn;
    wire [8:0] binary;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcdIn(bcdIn),
        .binary(binary)
    );
    task testcase001;

    begin
        test_num = 1;
        bcdIn = 9'h000;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bcdIn = 9'h009;
        #1;

        check_outputs(9'h009);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bcdIn = 9'h010;
        #1;

        check_outputs(9'h00A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bcdIn = 9'h042;
        #1;

        check_outputs(9'h02A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bcdIn = 9'h080;
        #1;

        check_outputs(9'h050);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bcdIn = 9'h099;
        #1;

        check_outputs(9'h063);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bcdIn = 9'h100;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bcdIn = 9'h115;
        #1;

        check_outputs(9'h10F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bcdIn = 9'h144;
        #1;

        check_outputs(9'h12C);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bcdIn = 9'h199;
        #1;

        check_outputs(9'h163);
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
        input [8:0] expected_binary;
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
