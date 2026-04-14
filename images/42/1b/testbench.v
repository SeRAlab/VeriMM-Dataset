`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg reset;
    reg start;
    wire done;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            $display("Reset sequence completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic functional check", test_num);
            reset_dut();

            a = 32'hABCD1234;
            b = 32'hFFFFFFFF;
            start = 1;

            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'hABCD1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify input B is ignored", test_num);
            reset_dut();

            a = 32'h5555AAAA;
            b = 32'h11112222;
            start = 1;

            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h5555AAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max and Min boundaries", test_num);
            reset_dut();

            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            start = 1;

            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input capture stability check", test_num);
            reset_dut();

            a = 32'h12345678;
            start = 1;

            @(posedge clk);
            #1;
            a = 32'h0;
            start = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Idle State", test_num);
            reset_dut();

            a = 32'h99999999;

            repeat(3) @(posedge clk);

            #2;
            #1;

            check_outputs(1'b0, 32'h0);
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
        input expected_done;
        input [31:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,a, b, clk, reset, start, done, result);
    end

endmodule
