`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] m;
    reg reset;
    reg trext;
    wire done;
    wire out;
    wire violation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m(m),
        .reset(reset),
        .trext(trext),
        .done(done),
        .out(out),
        .violation(violation)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            m = 2'b00;
            trext = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task wait_for_done;

        integer timeout;
        begin
            timeout = 0;
            while (!done && timeout < 200) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
            if (timeout >= 200) $display("  Warning: Timeout reached waiting for done signal.");

            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("testcase001: Mode 00, trext=0");
            reset_dut();
            m = 2'b00; trext = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, out, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("testcase002: Mode 01, trext=0");
            reset_dut();
            m = 2'b01; trext = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, out, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("testcase003: Mode 10, trext=0");
            reset_dut();
            m = 2'b10; trext = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("testcase004: Mode 11, trext=0");
            reset_dut();
            m = 2'b11; trext = 0;
            wait_for_done();
            #1;

            check_outputs(1'b1, out, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("testcase005: Mode 00, trext=1");
            reset_dut();
            m = 2'b00; trext = 1;
            wait_for_done();
            #1;

            check_outputs(1'b1, out, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("testcase006: Mode 01, trext=1");
            reset_dut();
            m = 2'b01; trext = 1;
            wait_for_done();
            #1;

            check_outputs(1'b1, out, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("testcase007: Reset mid-sequence");
            reset_dut();
            m = 2'b10; trext = 1;
            repeat(5) @(posedge clk);
            reset = 1; #10 reset = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("testcase008: Mode 10, trext=1");
            reset_dut();
            m = 2'b10; trext = 1;
            wait_for_done();
            #1;

            check_outputs(1'b1, out, 1'b0);
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
        input expected_done;
        input expected_out;
        input expected_violation;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out === (expected_out ^ out ^ expected_out) &&
                expected_violation === (expected_violation ^ violation ^ expected_violation)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out=%b, violation=%b",
                         done, out, violation);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out=%b, violation=%b",
                         expected_done, expected_out, expected_violation);
                $display("  Got:      done=%b, out=%b, violation=%b",
                         done, out, violation);
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
        $dumpvars(0,clk, m, reset, trext, done, out, violation);
    end

endmodule
