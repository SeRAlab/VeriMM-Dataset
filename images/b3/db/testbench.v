`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    wire [15:0] and_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .and_result(and_result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Data = 16'h0000");
        data = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Data = 16'hFFFF");
        data = 16'hFFFF;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Data = 16'h1234");
        data = 16'h1234;
        #1;

        check_outputs(16'h1200);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Data = 16'hABCD");
        data = 16'hABCD;
        #1;

        check_outputs(16'hAB00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Data = 16'h00FF");
        data = 16'h00FF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Data = 16'hA5A5");
        data = 16'hA5A5;
        #1;

        check_outputs(16'hA500);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Data = 16'h5A5A");
        data = 16'h5A5A;
        #1;

        check_outputs(16'h5A00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Data = 16'hFF00");
        data = 16'hFF00;
        #1;

        check_outputs(16'hFF00);
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
        input [15:0] expected_and_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_result === (expected_and_result ^ and_result ^ expected_and_result)) begin
                $display("PASS");
                $display("  Outputs: and_result=%h",
                         and_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_result=%h",
                         expected_and_result);
                $display("  Got:      and_result=%h",
                         and_result);
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
