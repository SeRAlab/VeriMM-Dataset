`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg [7:0] ctrl;
    wire clk_syn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_ref(clk_ref),
        .ctrl(ctrl),
        .clk_syn(clk_syn)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            ctrl = 8'h00;

            @(posedge clk_ref);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: ctrl=2 (Toggle every 2 cycles)", test_num);
            reset_dut();
            ctrl = 8'd2;
            #25;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: ctrl=4 (Toggle every 4 cycles)", test_num);
            reset_dut();
            ctrl = 8'd4;
            #45;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: ctrl=10 (Toggle every 10 cycles)", test_num);
            reset_dut();
            ctrl = 8'd10;
            #105;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: ctrl=1 (Toggle every cycle)", test_num);
            reset_dut();
            ctrl = 8'd1;
            #15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: ctrl=2 (Check transition to low phase)", test_num);
            reset_dut();
            ctrl = 8'd2;
            #45;
            #1;

            check_outputs(1'b0);
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
        input expected_clk_syn;
        begin
            if (expected_clk_syn === (expected_clk_syn ^ clk_syn ^ expected_clk_syn)) begin
                $display("PASS");
                $display("  Outputs: clk_syn=%b",
                         clk_syn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_syn=%b",
                         expected_clk_syn);
                $display("  Got:      clk_syn=%b",
                         clk_syn);
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
        $dumpvars(0,clk_ref, ctrl, clk_syn);
    end

endmodule
