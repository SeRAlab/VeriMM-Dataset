`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ar;
    reg [31:0] log;
    reg select;
    wire flag;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ar(ar),
        .log(log),
        .select(select),
        .flag(flag),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        ar = 32'hA5A5A5A5;
        log = 32'h5A5A5A5A;
        select = 0;
        #1;

        check_outputs(0, 32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ar = 32'h12345678;
        log = 32'h87654321;
        select = 1;
        #1;

        check_outputs(0, 32'h87654321);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ar = 32'h00000000;
        log = 32'hFFFFFFFF;
        select = 0;
        #1;

        check_outputs(1, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ar = 32'hFFFFFFFF;
        log = 32'h00000000;
        select = 1;
        #1;

        check_outputs(1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ar = 32'hFFFFFFFF;
        log = 32'h00000000;
        select = 0;
        #1;

        check_outputs(0, 32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ar = 32'hDEADBEEF;
        log = 32'hCAFEBABE;
        select = 1;
        #1;

        check_outputs(0, 32'hCAFEBABE);
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
        input expected_flag;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flag === (expected_flag ^ flag ^ expected_flag) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: flag=%b, result=%h",
                         flag, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag=%b, result=%h",
                         expected_flag, expected_result);
                $display("  Got:      flag=%b, result=%h",
                         flag, result);
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
