`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg [31:0] Instruction_if;
    reg [31:0] PC_if;
    reg R;
    reg clk;
    wire [31:0] Instruction_id;
    wire [31:0] PC_id;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .Instruction_if(Instruction_if),
        .PC_if(PC_if),
        .R(R),
        .clk(clk),
        .Instruction_id(Instruction_id),
        .PC_id(PC_id)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        R = 1;
        EN = 0;
        PC_if = 32'h0;
        Instruction_if = 32'h0;
        @(posedge clk);
        #1;
        R = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Basic Reset check", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Normal Data Capture (EN=1)", test_num);
        reset_dut();

        PC_if = 32'h0000_0004;
        Instruction_if = 32'h0084_2023;
        EN = 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0084_2023, 32'h0000_0004);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Hold state (EN=0)", test_num);
        reset_dut();


        PC_if = 32'h0000_0008;
        Instruction_if = 32'h00A5_2023;
        EN = 1;
        @(posedge clk);
        #1;


        EN = 0;
        PC_if = 32'hFFFF_FFFF;
        Instruction_if = 32'hDEAD_BEEF;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h00A5_2023, 32'h0000_0008);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset Priority (R=1, EN=1)", test_num);
        reset_dut();


        PC_if = 32'h0000_1000;
        Instruction_if = 32'h0000_0013;
        EN = 1;
        @(posedge clk);
        #1;


        R = 1;
        EN = 1;
        PC_if = 32'h0000_2000;
        Instruction_if = 32'hFFFF_FFFF;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Consecutive Updates", test_num);
        reset_dut();

        EN = 1;


        PC_if = 32'h10; Instruction_if = 32'hAA;
        @(posedge clk);
        #1;


        PC_if = 32'h20; Instruction_if = 32'hBB;
        @(posedge clk);
        #1;


        PC_if = 32'h30; Instruction_if = 32'hCC;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_00CC, 32'h0000_0030);
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
        input [31:0] expected_Instruction_id;
        input [31:0] expected_PC_id;
        begin
            if (expected_Instruction_id === (expected_Instruction_id ^ Instruction_id ^ expected_Instruction_id) &&
                expected_PC_id === (expected_PC_id ^ PC_id ^ expected_PC_id)) begin
                $display("PASS");
                $display("  Outputs: Instruction_id=%h, PC_id=%h",
                         Instruction_id, PC_id);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instruction_id=%h, PC_id=%h",
                         expected_Instruction_id, expected_PC_id);
                $display("  Got:      Instruction_id=%h, PC_id=%h",
                         Instruction_id, PC_id);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,EN, Instruction_if, PC_if, R, clk, Instruction_id, PC_id);
    end

endmodule
