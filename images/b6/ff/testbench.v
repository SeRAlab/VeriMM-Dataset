`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] input_vector;
    wire [15:0] output_vector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_vector(input_vector),
        .output_vector(output_vector)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All zeros");
        input_vector = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All ones");
        input_vector = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Simple byte swap");
        input_vector = 16'h1234;
        #1;

        check_outputs(16'h3412);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: High byte FF, low byte 00");
        input_vector = 16'hFF00;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Low byte FF, high byte 00");
        input_vector = 16'h00FF;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Pattern 0xABCD");
        input_vector = 16'hABCD;
        #1;

        check_outputs(16'hCDAB);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Checkerboard pattern AAAA");
        input_vector = 16'hAAAA;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Checkerboard pattern 5555");
        input_vector = 16'h5555;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Single bit high in first half");
        input_vector = 16'h8000;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Single bit high in second half");
        input_vector = 16'h0001;
        #1;

        check_outputs(16'h0100);
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
        input [15:0] expected_output_vector;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_vector === (expected_output_vector ^ output_vector ^ expected_output_vector)) begin
                $display("PASS");
                $display("  Outputs: output_vector=%h",
                         output_vector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_vector=%h",
                         expected_output_vector);
                $display("  Got:      output_vector=%h",
                         output_vector);
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
