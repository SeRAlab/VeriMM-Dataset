`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] EX_signal_i;
    reg [2:0] MEM_signal_i;
    reg [1:0] WB_signal_i;
    reg flush_select_i;
    reg stall_select_i;
    wire [1:0] EX_signal_o;
    wire [2:0] MEM_signal_o;
    wire [1:0] WB_signal_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_signal_i(EX_signal_i),
        .MEM_signal_i(MEM_signal_i),
        .WB_signal_i(WB_signal_i),
        .flush_select_i(flush_select_i),
        .stall_select_i(stall_select_i),
        .EX_signal_o(EX_signal_o),
        .MEM_signal_o(MEM_signal_o),
        .WB_signal_o(WB_signal_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Normal operation - Pass inputs to outputs");
            stall_select_i = 1'b0;
            flush_select_i = 1'b0;
            EX_signal_i    = 2'b10;
            MEM_signal_i   = 3'b101;
            WB_signal_i    = 2'b11;
            #1;

            check_outputs(2'b10, 3'b101, 2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Stall active - Outputs should be zero (undefined state)");
            stall_select_i = 1'b1;
            flush_select_i = 1'b0;
            EX_signal_i    = 2'b10;
            MEM_signal_i   = 3'b101;
            WB_signal_i    = 2'b11;

            #1;


            check_outputs(2'b00, 3'b000, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Flush active - Outputs should be zero (undefined state)");
            stall_select_i = 1'b0;
            flush_select_i = 1'b1;
            EX_signal_i    = 2'b01;
            MEM_signal_i   = 3'b110;
            WB_signal_i    = 2'b01;
            #1;

            check_outputs(2'b00, 3'b000, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Both Stall and Flush active - Outputs should be zero");
            stall_select_i = 1'b1;
            flush_select_i = 1'b1;
            EX_signal_i    = 2'b11;
            MEM_signal_i   = 3'b111;
            WB_signal_i    = 2'b11;
            #1;

            check_outputs(2'b00, 3'b000, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Resuming normal operation with different data");
            stall_select_i = 1'b0;
            flush_select_i = 1'b0;
            EX_signal_i    = 2'b01;
            MEM_signal_i   = 3'b011;
            WB_signal_i    = 2'b10;
            #1;

            check_outputs(2'b01, 3'b011, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Passing zeros in normal mode");
            stall_select_i = 1'b0;
            flush_select_i = 1'b0;
            EX_signal_i    = 2'b00;
            MEM_signal_i   = 3'b000;
            WB_signal_i    = 2'b00;
            #1;

            check_outputs(2'b00, 3'b000, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Passing all 1s in normal mode");
            stall_select_i = 1'b0;
            flush_select_i = 1'b0;
            EX_signal_i    = 2'b11;
            MEM_signal_i   = 3'b111;
            WB_signal_i    = 2'b11;
            #1;

            check_outputs(2'b11, 3'b111, 2'b11);
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
        input [1:0] expected_EX_signal_o;
        input [2:0] expected_MEM_signal_o;
        input [1:0] expected_WB_signal_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EX_signal_o === (expected_EX_signal_o ^ EX_signal_o ^ expected_EX_signal_o) &&
                expected_MEM_signal_o === (expected_MEM_signal_o ^ MEM_signal_o ^ expected_MEM_signal_o) &&
                expected_WB_signal_o === (expected_WB_signal_o ^ WB_signal_o ^ expected_WB_signal_o)) begin
                $display("PASS");
                $display("  Outputs: EX_signal_o=%h, MEM_signal_o=%h, WB_signal_o=%h",
                         EX_signal_o, MEM_signal_o, WB_signal_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EX_signal_o=%h, MEM_signal_o=%h, WB_signal_o=%h",
                         expected_EX_signal_o, expected_MEM_signal_o, expected_WB_signal_o);
                $display("  Got:      EX_signal_o=%h, MEM_signal_o=%h, WB_signal_o=%h",
                         EX_signal_o, MEM_signal_o, WB_signal_o);
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
