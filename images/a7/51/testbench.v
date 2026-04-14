`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg halt;
    reg rstd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .halt(halt),
        .rstd(rstd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rstd = 0;
            halt = 0;
            @(negedge clk);
            rstd = 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            #1;

            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            repeat (10) @(posedge clk);
            @(negedge clk) halt = 1;
            @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(32'd10, 32'd10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat (5) @(posedge clk);
            @(negedge clk) halt = 1;
            repeat (5) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(32'd5, 32'd5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat (5) @(posedge clk);
            @(negedge clk) halt = 1;
            @(posedge clk);
            @(negedge clk) halt = 0;
            repeat (3) @(posedge clk);
            @(negedge clk) halt = 1;
            @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(32'd8, 32'd8);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat (20) @(posedge clk);
            @(negedge clk) rstd = 0;
            @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(32'd0, 32'd0);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clk, halt, rstd);
    end

endmodule
