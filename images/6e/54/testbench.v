`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in;
    reg out_clk;
    reg out_resetn;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_clk(out_clk),
        .out_resetn(out_resetn),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        out_clk = 0;
        forever #5 out_clk = ~out_clk;
    end

        task reset_dut;

        begin
            out_resetn = 0;
            in = 0;
            @(posedge out_clk);
            #2 out_resetn = 1;
            @(posedge out_clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset");
            reset_dut();
            in = 4'b1010;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Synchronize 4'b1111");
            reset_dut();
            in = 4'b1111;


            @(posedge out_clk);
            #1;


            @(posedge out_clk);
            #1;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Pattern Transition 4'hA to 4'h5");
            reset_dut();


            in = 4'hA;
            wait_cycles(2);


            in = 4'h5;


            @(posedge out_clk);
            #1;
            if (out === 4'hA) begin

                @(posedge out_clk);
                #1;
                #1;

                check_outputs(4'h5);
            end else begin
                $display("FAIL: Latency error or ASYNC_CLK=0 logic used when ASYNC expected");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Reset mid-operation");
            reset_dut();
            in = 4'hF;
            wait_cycles(2);

            out_resetn = 0;
            #2;
            #1;

            check_outputs(4'h0);
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
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,in, out_clk, out_resetn, out);
    end

endmodule
