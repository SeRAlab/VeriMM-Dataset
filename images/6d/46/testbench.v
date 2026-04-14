`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg BSelSignal;
    reg [31:0] stage2_imm;
    reg [31:0] stage2_rs2_data;
    wire [31:0] stage2_alu_in2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BSelSignal(BSelSignal),
        .stage2_imm(stage2_imm),
        .stage2_rs2_data(stage2_rs2_data),
        .stage2_alu_in2(stage2_alu_in2)
    );
    task testcase001;

    begin
        $display("Running Testcase 001: BSelSignal=0 (rs2_data)...");
        test_num = 1;
        BSelSignal = 1'b0;
        stage2_imm = 32'hAAAA_AAAA;
        stage2_rs2_data = 32'h5555_5555;
        #1;

        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: BSelSignal=1 (imm)...");
        test_num = 2;
        BSelSignal = 1'b1;
        stage2_imm = 32'h1234_5678;
        stage2_rs2_data = 32'hFFFF_0000;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: BSelSignal=0, zeros check...");
        test_num = 3;
        BSelSignal = 1'b0;
        stage2_imm = 32'hFFFF_FFFF;
        stage2_rs2_data = 32'h0000_0000;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: BSelSignal=1, ones check...");
        test_num = 4;
        BSelSignal = 1'b1;
        stage2_imm = 32'hFFFF_FFFF;
        stage2_rs2_data = 32'h0000_0000;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Edge case switching...");
        test_num = 5;
        BSelSignal = 1'b1;
        stage2_imm = 32'hDEAD_BEEF;
        stage2_rs2_data = 32'hCAFE_BABE;
        #1;

        check_outputs(32'hDEAD_BEEF);

        #5;
        BSelSignal = 1'b0;
        #1;

        check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_stage2_alu_in2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stage2_alu_in2 === (expected_stage2_alu_in2 ^ stage2_alu_in2 ^ expected_stage2_alu_in2)) begin
                $display("PASS");
                $display("  Outputs: stage2_alu_in2=%h",
                         stage2_alu_in2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stage2_alu_in2=%h",
                         expected_stage2_alu_in2);
                $display("  Got:      stage2_alu_in2=%h",
                         stage2_alu_in2);
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
