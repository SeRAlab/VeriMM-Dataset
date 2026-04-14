`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg inc;
    reg reset;
    reg updown;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inc(inc),
        .reset(reset),
        .updown(updown),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            updown = 0;
            inc = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();


            #1;



            check_outputs(1, 4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            updown = 1;
            inc = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(2, 4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            updown = 1;
            inc = 1;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(3, 4'h8);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            updown = 0;
            inc = 0;
            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(4, 4'hF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            updown = 0;
            inc = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(5, 4'hC);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            updown = 1;
            inc = 1;
            repeat(9) @(posedge clk);
            #1;
            #1;

            check_outputs(6, 4'h2);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            updown = 1; inc = 1;
            repeat(3) @(posedge clk);
            #1;

            updown = 0; inc = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7, 4'h4);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            updown = 1;
            inc = 0;
            repeat(2) @(posedge clk);
            #1;
            inc = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8, 4'h6);
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
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, inc, reset, updown, Q);
    end

endmodule
