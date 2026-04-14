`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Flush;
    reg [31:0] InstructionIn;
    reg [31:0] PCValueIn;
    reg Stall;
    wire [31:0] InstructionOut;
    wire [31:0] PCValueOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Flush(Flush),
        .InstructionIn(InstructionIn),
        .PCValueIn(PCValueIn),
        .Stall(Stall),
        .InstructionOut(InstructionOut),
        .PCValueOut(PCValueOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Flush = 1;
            Stall = 0;
            InstructionIn = 32'h0;
            PCValueIn = 32'h0;
            tick();
            Flush = 0;
        end
        endtask
    task tick;

        begin
            @(posedge Clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Normal Update", test_num);
            reset_dut();

            InstructionIn = 32'hDEADBEEF;
            PCValueIn = 32'h00001000;
            Flush = 0;
            Stall = 0;

            tick();
            #1;

            check_outputs(32'hDEADBEEF, 32'h00001000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Stall Functionality", test_num);
            reset_dut();


            InstructionIn = 32'hAAAA_AAAA;
            PCValueIn = 32'h0000_0004;
            tick();


            Stall = 1;
            InstructionIn = 32'hBBBB_BBBB;
            PCValueIn = 32'h0000_0008;
            tick();


            #1;



            check_outputs(32'hAAAA_AAAA, 32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Flush Functionality", test_num);
            reset_dut();


            InstructionIn = 32'h1234_5678;
            PCValueIn = 32'h0000_2000;
            tick();


            Flush = 1;
            InstructionIn = 32'hFFFF_FFFF;
            PCValueIn = 32'h0000_FFFF;
            tick();


            #1;



            check_outputs(32'h0000_0000, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Flush Priority over Stall", test_num);
            reset_dut();


            InstructionIn = 32'hCAFE_BABE;
            PCValueIn = 32'h0000_3000;
            tick();


            Flush = 1;
            Stall = 1;
            InstructionIn = 32'h0;
            PCValueIn = 32'h0;
            tick();


            #1;



            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Stall Release Recovery", test_num);
            reset_dut();


            Stall = 1;
            InstructionIn = 32'h1111_1111;
            PCValueIn = 32'h0000_0010;
            tick();


            Stall = 0;
            InstructionIn = 32'h2222_2222;
            PCValueIn = 32'h0000_0020;
            tick();

            #1;


            check_outputs(32'h2222_2222, 32'h0000_0020);
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
        input [31:0] expected_InstructionOut;
        input [31:0] expected_PCValueOut;
        begin
            if (expected_InstructionOut === (expected_InstructionOut ^ InstructionOut ^ expected_InstructionOut) &&
                expected_PCValueOut === (expected_PCValueOut ^ PCValueOut ^ expected_PCValueOut)) begin
                $display("PASS");
                $display("  Outputs: InstructionOut=%h, PCValueOut=%h",
                         InstructionOut, PCValueOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: InstructionOut=%h, PCValueOut=%h",
                         expected_InstructionOut, expected_PCValueOut);
                $display("  Got:      InstructionOut=%h, PCValueOut=%h",
                         InstructionOut, PCValueOut);
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
        $dumpvars(0,Clk, Flush, InstructionIn, PCValueIn, Stall, InstructionOut, PCValueOut);
    end

endmodule
