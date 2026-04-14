`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] PC_input;
    reg clk;
    reg en;
    reg rst;
    wire [31:0] PC_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC_input(PC_input),
        .clk(clk),
        .en(en),
        .rst(rst),
        .PC_output(PC_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            PC_input = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load value when enable is high", test_num);
            reset_dut();
            PC_input = 32'hDEADBEEF;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Hold value when enable is low", test_num);
            reset_dut();

            PC_input = 32'h12345678;
            en = 1;
            @(posedge clk);
            #1;

            en = 0;
            PC_input = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Synchronous reset priority over enable", test_num);
            reset_dut();

            PC_input = 32'hAAAA5555;
            en = 1;
            @(posedge clk);
            #1;

            rst = 1;
            en = 1;
            PC_input = 32'hBBBBCCCC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Multiple consecutive loads", test_num);
            reset_dut();
            en = 1;
            PC_input = 32'h00000001;
            @(posedge clk);
            #1;
            PC_input = 32'h00000002;
            @(posedge clk);
            #1;
            PC_input = 32'h00000003;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify output doesn't change on input change without clock", test_num);
            reset_dut();
            en = 1;
            PC_input = 32'h11112222;
            @(posedge clk);
            #1;

            PC_input = 32'h33334444;
            #2;
            #1;

            check_outputs(32'h11112222);
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
        input [31:0] expected_PC_output;
        begin
            if (expected_PC_output === (expected_PC_output ^ PC_output ^ expected_PC_output)) begin
                $display("PASS");
                $display("  Outputs: PC_output=%h",
                         PC_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_output=%h",
                         expected_PC_output);
                $display("  Got:      PC_output=%h",
                         PC_output);
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
        $dumpvars(0,PC_input, clk, en, rst, PC_output);
    end

endmodule
