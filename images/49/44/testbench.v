`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IRWrite;
    reg [31:0] Instr_i;
    reg clk;
    reg rst_n;
    wire [31:0] Instr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IRWrite(IRWrite),
        .Instr_i(Instr_i),
        .clk(clk),
        .rst_n(rst_n),
        .Instr_o(Instr_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1;
            IRWrite = 0;
            Instr_i = 32'h0;
            @(posedge clk);
            #1;
            rst_n = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Write");
            reset_dut();
            IRWrite = 1;
            Instr_i = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Hold Value (IRWrite=0)");
            reset_dut();

            IRWrite = 1;
            Instr_i = 32'h12345678;
            @(posedge clk);
            #1;

            IRWrite = 0;
            Instr_i = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Successive Updates");
            reset_dut();
            IRWrite = 1;
            Instr_i = 32'hAAAA_BBBB;
            @(posedge clk);
            #1;
            Instr_i = 32'hCCCC_DDDD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCCCC_DDDD);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Priority");
            reset_dut();
            IRWrite = 1;
            Instr_i = 32'h5555_AAAA;
            rst_n = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Multi-cycle Data Persistence");
            reset_dut();
            IRWrite = 1;
            Instr_i = 32'h87654321;
            @(posedge clk);
            #1;
            IRWrite = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h87654321);
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
        input [31:0] expected_Instr_o;
        begin
            if (expected_Instr_o === (expected_Instr_o ^ Instr_o ^ expected_Instr_o)) begin
                $display("PASS");
                $display("  Outputs: Instr_o=%h",
                         Instr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instr_o=%h",
                         expected_Instr_o);
                $display("  Got:      Instr_o=%h",
                         Instr_o);
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
        $dumpvars(0,IRWrite, Instr_i, clk, rst_n, Instr_o);
    end

endmodule
