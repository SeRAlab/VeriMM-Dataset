`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] Instruction_Code;
    reg Reset;
    wire [7:0] IF_ID_Instruction_Code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Instruction_Code(Instruction_Code),
        .Reset(Reset),
        .IF_ID_Instruction_Code(IF_ID_Instruction_Code)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 0;
            Instruction_Code = 8'h00;
            #15;
            Reset = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Instruction Capture (0xAA)", test_num);
            reset_dut();

            @(posedge Clk);
            Instruction_Code <= 8'hAA;

            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Instruction Capture (0x55)", test_num);
            reset_dut();

            @(posedge Clk);
            Instruction_Code <= 8'h55;

            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Edge Case - Capture 0xFF", test_num);
            reset_dut();

            @(posedge Clk);
            Instruction_Code <= 8'hFF;

            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input changes mid-cycle", test_num);
            reset_dut();

            @(posedge Clk);
            Instruction_Code <= 8'h12;
            #3;
            Instruction_Code <= 8'h34;

            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asynchronous Reset verification", test_num);
            reset_dut();


            @(posedge Clk);
            Instruction_Code <= 8'hDE;
            @(posedge Clk);
            #1;


            Reset = 0;
            #2;
            #1;

            check_outputs(8'h00);
            Reset = 1;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Captures", test_num);
            reset_dut();

            @(posedge Clk);
            Instruction_Code <= 8'h01;
            @(posedge Clk);
            Instruction_Code <= 8'h02;
            @(posedge Clk);
            Instruction_Code <= 8'h03;

            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h03);
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
        input [7:0] expected_IF_ID_Instruction_Code;
        begin
            if (expected_IF_ID_Instruction_Code === (expected_IF_ID_Instruction_Code ^ IF_ID_Instruction_Code ^ expected_IF_ID_Instruction_Code)) begin
                $display("PASS");
                $display("  Outputs: IF_ID_Instruction_Code=%h",
                         IF_ID_Instruction_Code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IF_ID_Instruction_Code=%h",
                         expected_IF_ID_Instruction_Code);
                $display("  Got:      IF_ID_Instruction_Code=%h",
                         IF_ID_Instruction_Code);
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
        $dumpvars(0,Clk, Instruction_Code, Reset, IF_ID_Instruction_Code);
    end

endmodule
