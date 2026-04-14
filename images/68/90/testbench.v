`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg PCWre;
    reg clk;
    reg [31:0] input_pc;
    reg reset;
    wire [31:0] output_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCWre(PCWre),
        .clk(clk),
        .input_pc(input_pc),
        .reset(reset),
        .output_pc(output_pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        PCWre = 0;
        input_pc = 32'h0;
        @(posedge clk);
        #1;
        reset = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Reset Check", test_num);
        reset_dut();
        reset = 0;
        PCWre = 1;
        input_pc = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Write Enabled Load", test_num);
        reset_dut();
        PCWre = 1;
        input_pc = 32'h12345678;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Write Disabled Hold", test_num);
        reset_dut();


        PCWre = 1;
        input_pc = 32'hAAAA_BBBB;
        @(posedge clk);
        #1;


        PCWre = 0;
        input_pc = 32'hCCCC_DDDD;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Sequential Updates", test_num);
        reset_dut();
        PCWre = 1;

        input_pc = 32'h4;
        @(posedge clk);
        #1;

        input_pc = 32'h8;
        @(posedge clk);
        #1;

        input_pc = 32'hC;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000000C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Boundary Values", test_num);
        reset_dut();
        PCWre = 1;
        input_pc = 32'hFFFF_FFFC;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFF_FFFC);
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
        input [31:0] expected_output_pc;
        begin
            if (expected_output_pc === (expected_output_pc ^ output_pc ^ expected_output_pc)) begin
                $display("PASS");
                $display("  Outputs: output_pc=%h",
                         output_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_pc=%h",
                         expected_output_pc);
                $display("  Got:      output_pc=%h",
                         output_pc);
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
        $dumpvars(0,PCWre, clk, input_pc, reset, output_pc);
    end

endmodule
