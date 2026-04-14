`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IF_ID_Write;
    reg [31:0] Instruction_in;
    reg [31:0] PC_4_in;
    reg clk;
    reg rst;
    wire [31:0] Instruction_out;
    wire [31:0] PC_4_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IF_ID_Write(IF_ID_Write),
        .Instruction_in(Instruction_in),
        .PC_4_in(PC_4_in),
        .clk(clk),
        .rst(rst),
        .Instruction_out(Instruction_out),
        .PC_4_out(PC_4_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            IF_ID_Write = 0;
            Instruction_in = 32'h0;
            PC_4_in = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write Operation", test_num);
            reset_dut();


            IF_ID_Write = 1;
            PC_4_in = 32'h00000004;
            Instruction_in = 32'h01234567;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h01234567, 32'h00000004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Low (Stall)", test_num);
            reset_dut();


            IF_ID_Write = 0;
            PC_4_in = 32'h00000008;
            Instruction_in = 32'hABCDEF01;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence/Hold Value", test_num);
            reset_dut();


            IF_ID_Write = 1;
            PC_4_in = 32'h0000000C;
            Instruction_in = 32'h5555AAAA;
            @(posedge clk);
            #1;


            IF_ID_Write = 0;
            PC_4_in = 32'hFFFFFFFF;
            Instruction_in = 32'hEEEEEEEE;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h5555AAAA, 32'h0000000C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Updates", test_num);
            reset_dut();


            IF_ID_Write = 1;
            PC_4_in = 32'h00000010;
            Instruction_in = 32'h11111111;
            @(posedge clk);
            #1;


            PC_4_in = 32'h00000014;
            Instruction_in = 32'h22222222;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h22222222, 32'h00000014);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();


            IF_ID_Write = 1;
            PC_4_in = 32'h00000020;
            Instruction_in = 32'h99999999;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #2;
            rst = 0;

            #1;


            check_outputs(32'h00000000, 32'h00000000);
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
        input [31:0] expected_Instruction_out;
        input [31:0] expected_PC_4_out;
        begin
            if (expected_Instruction_out === (expected_Instruction_out ^ Instruction_out ^ expected_Instruction_out) &&
                expected_PC_4_out === (expected_PC_4_out ^ PC_4_out ^ expected_PC_4_out)) begin
                $display("PASS");
                $display("  Outputs: Instruction_out=%h, PC_4_out=%h",
                         Instruction_out, PC_4_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instruction_out=%h, PC_4_out=%h",
                         expected_Instruction_out, expected_PC_4_out);
                $display("  Got:      Instruction_out=%h, PC_4_out=%h",
                         Instruction_out, PC_4_out);
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
        $dumpvars(0,IF_ID_Write, Instruction_in, PC_4_in, clk, rst, Instruction_out, PC_4_out);
    end

endmodule
