`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_i;
    reg ori_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_i(data_i),
        .ori_i(ori_i),
        .data_o(data_o)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero extension (ori_i=1) with small positive value");
            data_i = 16'h0005;
            ori_i = 1;
            #1;

            check_outputs(32'h00000005);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Zero extension (ori_i=1) with MSB set (16-bit negative looking)");
            data_i = 16'h8001;
            ori_i = 1;
            #1;

            check_outputs(32'h00008001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Zero extension (ori_i=1) with all ones");
            data_i = 16'hFFFF;
            ori_i = 1;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Sign extension (ori_i=0) with positive value (MSB=0)");
            data_i = 16'h7ABC;
            ori_i = 0;
            #1;

            check_outputs(32'h00007ABC);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Sign extension (ori_i=0) with negative value (MSB=1)");
            data_i = 16'h8000;
            ori_i = 0;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sign extension (ori_i=0) with all ones");
            data_i = 16'hFFFF;
            ori_i = 0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Sign extension (ori_i=0) with zero");
            data_i = 16'h0000;
            ori_i = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Zero extension (ori_i=1) with zero");
            data_i = 16'h0000;
            ori_i = 1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Transition from Sign to Zero extension for same input");
            data_i = 16'hA5A5;
            ori_i = 0;
            #1;
            #1;

            check_outputs(32'hFFFFA5A5);

            ori_i = 1;
            #1;

            check_outputs(32'h0000A5A5);
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
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
