`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ErrorOvE;
    reg ErrorRlE;
    reg InterruptRequest;
    reg [31:0] PCE;
    reg clk;
    reg reset;
    wire ErrorOvM;
    wire ErrorRlM;
    wire [31:0] PCM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ErrorOvE(ErrorOvE),
        .ErrorRlE(ErrorRlE),
        .InterruptRequest(InterruptRequest),
        .PCE(PCE),
        .clk(clk),
        .reset(reset),
        .ErrorOvM(ErrorOvM),
        .ErrorRlM(ErrorRlM),
        .PCM(PCM)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            InterruptRequest = 0;
            ErrorOvE = 0;
            ErrorRlE = 0;
            PCE = 32'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test 001: Normal operation - ErrorOvE and PCE transfer");
            InterruptRequest = 0;
            ErrorOvE = 1;
            ErrorRlE = 0;
            PCE = 32'hA5A5A5A5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 0, 32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test 002: InterruptRequest priority over inputs");
            InterruptRequest = 1;
            ErrorOvE = 1;
            ErrorRlE = 1;
            PCE = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test 003: Reset signal priority over inputs");
            InterruptRequest = 0;
            ErrorOvE = 1;
            ErrorRlE = 1;
            PCE = 32'h12345678;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test 004: Normal operation - ErrorRlE and alternate PCE");
            InterruptRequest = 0;
            ErrorOvE = 0;
            ErrorRlE = 1;
            PCE = 32'hDEADBEEF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test 005: Normal operation - Multiple signals and zero PC");
            InterruptRequest = 0;
            ErrorOvE = 1;
            ErrorRlE = 1;
            PCE = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, 1, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test 006: Transition from Interrupt to Normal Data");

            InterruptRequest = 1;
            ErrorOvE = 1;
            PCE = 32'h11112222;
            @(posedge clk);
            #1;


            InterruptRequest = 0;
            ErrorOvE = 0;
            ErrorRlE = 1;
            PCE = 32'h33334444;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 1, 32'h33334444);
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
        input expected_ErrorOvM;
        input expected_ErrorRlM;
        input [31:0] expected_PCM;
        begin
            if (expected_ErrorOvM === (expected_ErrorOvM ^ ErrorOvM ^ expected_ErrorOvM) &&
                expected_ErrorRlM === (expected_ErrorRlM ^ ErrorRlM ^ expected_ErrorRlM) &&
                expected_PCM === (expected_PCM ^ PCM ^ expected_PCM)) begin
                $display("PASS");
                $display("  Outputs: ErrorOvM=%b, ErrorRlM=%b, PCM=%h",
                         ErrorOvM, ErrorRlM, PCM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ErrorOvM=%b, ErrorRlM=%b, PCM=%h",
                         expected_ErrorOvM, expected_ErrorRlM, expected_PCM);
                $display("  Got:      ErrorOvM=%b, ErrorRlM=%b, PCM=%h",
                         ErrorOvM, ErrorRlM, PCM);
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
        $dumpvars(0,ErrorOvE, ErrorRlE, InterruptRequest, PCE, clk, reset, ErrorOvM, ErrorRlM, PCM);
    end

endmodule
