`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg flush;
    reg reset;
    reg [15:0] toIR;
    reg [15:0] toPC;
    reg [15:0] toPCInc;
    reg tofirst_multiple;
    wire [15:0] IR;
    wire [15:0] PC;
    wire [15:0] PCInc;
    wire first_multiple;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .flush(flush),
        .reset(reset),
        .toIR(toIR),
        .toPC(toPC),
        .toPCInc(toPCInc),
        .tofirst_multiple(tofirst_multiple),
        .IR(IR),
        .PC(PC),
        .PCInc(PCInc),
        .first_multiple(first_multiple)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            flush = 0;
            toIR = 0;
            toPC = 0;
            toPCInc = 0;
            tofirst_multiple = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Data Capture", test_num);
            reset_dut();

            toPCInc = 16'h1004;
            toPC = 16'h1000;
            toIR = 16'hDEAD;
            tofirst_multiple = 1'b1;
            flush = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hDEAD, 16'h1000, 16'h1004, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Flush Operation (NOP)", test_num);
            reset_dut();

            toPCInc = 16'h2004;
            toPC = 16'h2000;
            toIR = 16'hBEEF;
            tofirst_multiple = 1'b1;
            flush = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000, 16'h2000, 16'h2004, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Functionality", test_num);
            reset_dut();


            toPCInc = 16'hAAAA;
            toPC = 16'hBBBB;
            toIR = 16'hCCCC;
            tofirst_multiple = 1'b1;
            @(posedge clk);
            #2;


            reset = 1;
            @(posedge clk);
            #2;
            reset = 0;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Recovery from Flush", test_num);
            reset_dut();


            flush = 1;
            toPCInc = 16'h3004; toPC = 16'h3000; toIR = 16'hFFFF; tofirst_multiple = 1;
            @(posedge clk);
            #2;


            flush = 0;
            toPCInc = 16'h4004; toPC = 16'h4000; toIR = 16'h5555; tofirst_multiple = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h5555, 16'h4000, 16'h4004, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Values (All Ones)", test_num);
            reset_dut();

            toPCInc = 16'hFFFF;
            toPC = 16'hFFFF;
            toIR = 16'hFFFF;
            tofirst_multiple = 1'b1;
            flush = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF, 1'b1);
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
        input [15:0] expected_IR;
        input [15:0] expected_PC;
        input [15:0] expected_PCInc;
        input expected_first_multiple;
        begin
            if (expected_IR === (expected_IR ^ IR ^ expected_IR) &&
                expected_PC === (expected_PC ^ PC ^ expected_PC) &&
                expected_PCInc === (expected_PCInc ^ PCInc ^ expected_PCInc) &&
                expected_first_multiple === (expected_first_multiple ^ first_multiple ^ expected_first_multiple)) begin
                $display("PASS");
                $display("  Outputs: IR=%h, PC=%h, PCInc=%h, first_multiple=%b",
                         IR, PC, PCInc, first_multiple);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IR=%h, PC=%h, PCInc=%h, first_multiple=%b",
                         expected_IR, expected_PC, expected_PCInc, expected_first_multiple);
                $display("  Got:      IR=%h, PC=%h, PCInc=%h, first_multiple=%b",
                         IR, PC, PCInc, first_multiple);
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
        $dumpvars(0,clk, flush, reset, toIR, toPC, toPCInc, tofirst_multiple, IR, PC, PCInc, first_multiple);
    end

endmodule
