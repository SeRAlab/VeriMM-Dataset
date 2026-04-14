`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] inA;
    reg [1:0] inB;
    reg selector;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inA(inA),
        .inB(inB),
        .selector(selector),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        inA = 2'b01;
        inB = 2'b10;
        selector = 1'b0;
        $display("Test %0d: selector=0, inA=01, inB=10", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        inA = 2'b01;
        inB = 2'b10;
        selector = 1'b1;
        $display("Test %0d: selector=1, inA=01, inB=10", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        inA = 2'b11;
        inB = 2'b00;
        selector = 1'b0;
        $display("Test %0d: selector=0, inA=11, inB=00", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        inA = 2'b11;
        inB = 2'b00;
        selector = 1'b1;
        $display("Test %0d: selector=1, inA=11, inB=00", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        inA = 2'b10;
        inB = 2'b11;
        selector = 1'b0;
        $display("Test %0d: selector=0, inA=10, inB=11", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        inA = 2'b10;
        inB = 2'b11;
        selector = 1'b1;
        $display("Test %0d: selector=1, inA=10, inB=11", test_num);
        #1;

        check_outputs(2'b11);
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
        input [1:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
