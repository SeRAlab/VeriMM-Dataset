`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [31:0] in0;
    reg [31:0] in1;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in0(in0),
        .in1(in1),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Enable=0, inputs=all 1s");
        enable = 0;
        in0 = 32'hFFFFFFFF;
        in1 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Enable=1, bitwise OR (5s and As)");
        enable = 1;
        in0 = 32'h55555555;
        in1 = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Enable=1, in0 OR 0");
        enable = 1;
        in0 = 32'h12345678;
        in1 = 32'h00000000;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Enable=1, sparse bits");
        enable = 1;
        in0 = 32'h80000001;
        in1 = 32'h00000001;
        #1;

        check_outputs(32'h80000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Enable=1, overlapping bits");
        enable = 1;
        in0 = 32'hF0F0F0F0;
        in1 = 32'hFF00FF00;
        #1;

        check_outputs(32'hFFF0FFF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Enable transition high -> low");
        enable = 1;
        in0 = 32'hABCD1234;
        in1 = 32'h4321DCBA;
        #5;
        enable = 0;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
