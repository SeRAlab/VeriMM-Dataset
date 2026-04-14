`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg SDR;
    reg clk;
    reg clrb;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SDR(SDR),
        .clk(clk),
        .clrb(clrb),
        .Q(Q)
    );

        task reset_dut;

        begin
            clrb = 0;
            SDR = 0;
            @(posedge clk);
            #1;
            clrb = 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 0;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk) SDR = 0;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 1;

            @(posedge clk) clrb = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 0;
            @(posedge clk) SDR = 1;
            @(posedge clk) SDR = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,SDR, clk, clrb, Q);
    end

endmodule
