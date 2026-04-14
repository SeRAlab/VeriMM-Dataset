`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] i_pc;
    reg rst;
    wire [31:0] o_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_pc(i_pc),
        .rst(rst),
        .o_pc(o_pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_pc = 32'h0;
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
            $display("Testcase %0d: Basic Reset Verification", test_num);
            reset_dut();


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load standard address", test_num);
            reset_dut();
            i_pc = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Load maximum boundary address", test_num);
            reset_dut();
            i_pc = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset Priority", test_num);
            reset_dut();
            i_pc = 32'hA5A5A5A5;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential Update", test_num);
            reset_dut();
            i_pc = 32'h00000004;
            @(posedge clk);
            #1;
            i_pc = 32'h00000008;
            @(posedge clk);
            #1;
            i_pc = 32'h0000000C;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000000C);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Bit Pattern Alternation", test_num);
            reset_dut();
            i_pc = 32'hAAAAAAAA;
            @(posedge clk);
            #1;
            i_pc = 32'h55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_o_pc;
        begin
            if (expected_o_pc === (expected_o_pc ^ o_pc ^ expected_o_pc)) begin
                $display("PASS");
                $display("  Outputs: o_pc=%h",
                         o_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_pc=%h",
                         expected_o_pc);
                $display("  Got:      o_pc=%h",
                         o_pc);
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
        $dumpvars(0,clk, i_pc, rst, o_pc);
    end

endmodule
