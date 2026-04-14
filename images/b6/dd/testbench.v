`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in0;
    wire out;
    wire rd_rst_asreg_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .out(out),
        .rd_rst_asreg_reg(rd_rst_asreg_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in0 = 0;

            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Transition 0 -> 1", test_num);
            in0 = 1;

            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Transition 1 -> 0", test_num);
            in0 = 1;
            @(posedge clk);
            in0 = 0;

            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Sustained High Input", test_num);
            in0 = 1;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Input Pulse Synchronization", test_num);
            in0 = 1;
            @(posedge clk);
            #1;
            in0 = 0;


            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Rapid Toggle Sequence", test_num);
            in0 = 1; @(posedge clk);
            in0 = 0; @(posedge clk);
            in0 = 1; @(posedge clk);
            in0 = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_out;
        input expected_rd_rst_asreg_reg;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_rd_rst_asreg_reg === (expected_rd_rst_asreg_reg ^ rd_rst_asreg_reg ^ expected_rd_rst_asreg_reg)) begin
                $display("PASS");
                $display("  Outputs: out=%b, rd_rst_asreg_reg=%b",
                         out, rd_rst_asreg_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, rd_rst_asreg_reg=%b",
                         expected_out, expected_rd_rst_asreg_reg);
                $display("  Got:      out=%b, rd_rst_asreg_reg=%b",
                         out, rd_rst_asreg_reg);
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
        $dumpvars(0,clk, in0, out, rd_rst_asreg_reg);
    end

endmodule
