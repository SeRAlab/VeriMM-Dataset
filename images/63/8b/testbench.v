`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] ctrl;
    wire [7:0] stored_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl(ctrl),
        .stored_val(stored_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrl = 4'h0;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ctrl = 4'hA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ctrl = 4'h5;
            @(posedge clk);
            #1;
            ctrl = 4'hC;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h5C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ctrl = 4'h1; @(posedge clk); #1;
            ctrl = 4'h2; @(posedge clk); #1;
            ctrl = 4'h3; @(posedge clk); #1;

            #1;


            check_outputs(8'h23);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            ctrl = 4'hF; @(posedge clk); #1;
            ctrl = 4'hF; @(posedge clk); #1;

            #1;


            check_outputs(8'hFF);
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
        input [7:0] expected_stored_val;
        begin
            if (expected_stored_val === (expected_stored_val ^ stored_val ^ expected_stored_val)) begin
                $display("PASS");
                $display("  Outputs: stored_val=%h",
                         stored_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stored_val=%h",
                         expected_stored_val);
                $display("  Got:      stored_val=%h",
                         stored_val);
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
        $dumpvars(0,clk, ctrl, stored_val);
    end

endmodule
