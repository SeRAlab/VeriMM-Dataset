`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] pc;
    reg rst;
    wire [31:0] newpc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pc(pc),
        .rst(rst),
        .newpc(newpc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pc = 32'h0;
            @(posedge clk);
            #2;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset state", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Loading address 0x00000004", test_num);
            reset_dut();
            pc = 32'h00000004;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Loading address 0xABCDE000", test_num);
            reset_dut();
            pc = 32'hABCDE000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hABCDE000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Loading address 0xFFFFFFFF", test_num);
            reset_dut();
            pc = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying multi-cycle update", test_num);
            reset_dut();

            pc = 32'h11111111;
            @(posedge clk);
            #2;

            pc = 32'h22222222;
            @(posedge clk);
            #2;

            pc = 32'h33333333;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h33333333);
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
        input [31:0] expected_newpc;
        begin
            if (expected_newpc === (expected_newpc ^ newpc ^ expected_newpc)) begin
                $display("PASS");
                $display("  Outputs: newpc=%h",
                         newpc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: newpc=%h",
                         expected_newpc);
                $display("  Got:      newpc=%h",
                         newpc);
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
        $dumpvars(0,clk, pc, rst, newpc);
    end

endmodule
