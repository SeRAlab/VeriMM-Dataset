`timescale 1ns/1ps

module clock_gating_reset_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_gating_ctrl;
    reg rst;
    wire gated_rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gating_reset dut (
        .clk(clk),
        .clk_gating_ctrl(clk_gating_ctrl),
        .rst(rst),
        .gated_rst(gated_rst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clk_gating_ctrl = 0;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Control High, Reset High");
            reset_dut();
            clk_gating_ctrl = 1'b1;
            rst = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Control High, Reset Low");
            reset_dut();
            clk_gating_ctrl = 1'b1;
            rst = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Control Low, Reset High");
            reset_dut();
            clk_gating_ctrl = 1'b0;
            rst = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Control Low, Reset Low");
            reset_dut();
            clk_gating_ctrl = 1'b0;
            rst = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Control toggle during active reset");
            reset_dut();
            rst = 1'b1;
            clk_gating_ctrl = 1'b0;
            @(posedge clk);
            #1;
            clk_gating_ctrl = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_gating_reset Testbench");
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
        input expected_gated_rst;
        begin
            if (expected_gated_rst === (expected_gated_rst ^ gated_rst ^ expected_gated_rst)) begin
                $display("PASS");
                $display("  Outputs: gated_rst=%b",
                         gated_rst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_rst=%b",
                         expected_gated_rst);
                $display("  Got:      gated_rst=%b",
                         gated_rst);
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
        $dumpvars(0,clk, clk_gating_ctrl, rst, gated_rst);
    end

endmodule
