`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IRWr;
    reg clk;
    reg [31:0] imOut;
    wire [31:0] instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IRWr(IRWr),
        .clk(clk),
        .imOut(imOut),
        .instruction(instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            IRWr = 0;
            imOut = 32'b0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write Operation");
            reset_dut();
            IRWr = 1;
            imOut = 32'hA5A5A5A5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Hold Value when IRWr is Low");
            reset_dut();

            IRWr = 1;
            imOut = 32'h12345678;
            @(posedge clk);
            #2;

            @(negedge clk);
            IRWr = 0;
            imOut = 32'hFFFFFFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write All Ones");
            reset_dut();
            IRWr = 1;
            imOut = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write All Zeros");
            reset_dut();

            IRWr = 1;
            imOut = 32'hDEADBEEF;
            @(posedge clk);
            #2;
            @(negedge clk);
            imOut = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Consecutive Writes");
            reset_dut();
            IRWr = 1;

            imOut = 32'h11111111;
            @(posedge clk);
            #2;

            @(negedge clk);
            imOut = 32'h22222222;
            @(posedge clk);
            #2;

            @(negedge clk);
            imOut = 32'h33333333;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h33333333);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Asynchronous change of imOut");
            reset_dut();
            IRWr = 1;
            imOut = 32'hAAAA_5555;
            @(posedge clk);
            #2;

            #3;
            imOut = 32'hCCCC_3333;
            #1;

            #1;


            check_outputs(32'hAAAA_5555);
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
        input [31:0] expected_instruction;
        begin
            if (expected_instruction === (expected_instruction ^ instruction ^ expected_instruction)) begin
                $display("PASS");
                $display("  Outputs: instruction=%h",
                         instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction=%h",
                         expected_instruction);
                $display("  Got:      instruction=%h",
                         instruction);
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
        $dumpvars(0,IRWr, clk, imOut, instruction);
    end

endmodule
