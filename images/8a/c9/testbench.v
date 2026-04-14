`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [15:0] mem_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .mem_out(mem_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: All Zeros");
        data_in = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Walking One (Bit 0)");
        data_in = 8'h01;
        #1;

        check_outputs(16'h0007);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Walking One (Bit 1)");
        data_in = 8'h02;
        #1;

        check_outputs(16'h0013);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Walking One (Bit 2)");
        data_in = 8'h04;
        #1;

        check_outputs(16'h0026);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Walking One (Bit 3)");
        data_in = 8'h08;
        #1;

        check_outputs(16'h004B);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Walking One (Bit 4)");
        data_in = 8'h10;
        #1;

        check_outputs(16'h0181);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Walking One (Bit 7)");
        data_in = 8'h80;
        #1;

        check_outputs(16'h0888);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: All Ones");
        data_in = 8'hFF;
        #1;

        check_outputs(16'h0F77);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Alternating Bits 10101010");
        data_in = 8'hAA;
        #1;

        check_outputs(16'h0A58);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Alternating Bits 01010101");
        data_in = 8'h55;
        #1;

        check_outputs(16'h052F);
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
        input [15:0] expected_mem_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_out === (expected_mem_out ^ mem_out ^ expected_mem_out)) begin
                $display("PASS");
                $display("  Outputs: mem_out=%h",
                         mem_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_out=%h",
                         expected_mem_out);
                $display("  Got:      mem_out=%h",
                         mem_out);
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
