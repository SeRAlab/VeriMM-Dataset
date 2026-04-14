`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dividend;
    reg [31:0] divisor;
    reg resetn;
    wire done;
    wire [31:0] quotient;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .resetn(resetn),
        .done(done),
        .quotient(quotient)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        dividend = 0;
        divisor = 0;
        @(posedge clk);
        #2;
        resetn = 1;
        @(posedge clk);
    end
        endtask
    task wait_for_done;

    begin

        fork
            begin
                wait(done == 1'b1);
            end
            begin
                #5000;
            end
        join_any
        disable fork;

        if (!done) begin
            $display("TIMEOUT waiting for done signal");
        end

        #1;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 100 / 4", test_num);
        reset_dut();
        dividend = 32'd100;
        divisor = 32'd4;
        wait_for_done();
        #1;

        check_outputs(1'b1, 32'd25);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 5 / 10", test_num);
        reset_dut();
        dividend = 32'd5;
        divisor = 32'd10;
        wait_for_done();
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0xFFFFFFFE / 2", test_num);
        reset_dut();
        dividend = 32'hFFFFFFFE;
        divisor = 32'd2;
        wait_for_done();
        #1;

        check_outputs(1'b1, 32'h7FFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: -50 / 5", test_num);
        reset_dut();
        dividend = -32'sd50;
        divisor = 32'sd5;
        wait_for_done();
        #1;

        check_outputs(1'b1, -32'sd10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 20 / -4", test_num);
        reset_dut();
        dividend = 32'sd20;
        divisor = -32'sd4;
        wait_for_done();
        #1;

        check_outputs(1'b1, -32'sd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: -100 / -10", test_num);
        reset_dut();
        dividend = -32'sd100;
        divisor = -32'sd10;
        wait_for_done();
        #1;

        check_outputs(1'b1, 32'sd10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 123456 / 1", test_num);
        reset_dut();
        dividend = 32'd123456;
        divisor = 32'd1;
        wait_for_done();
        #1;

        check_outputs(1'b1, 32'd123456);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0 / 50", test_num);
        reset_dut();
        dividend = 32'd0;
        divisor = 32'd50;
        wait_for_done();
        #1;

        check_outputs(1'b1, 32'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 0xABCDE / 0xABCDE", test_num);
        reset_dut();
        dividend = 32'hABCDE;
        divisor = 32'hABCDE;
        wait_for_done();
        #1;

        check_outputs(1'b1, 32'd1);
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
        testcase009();
        
        
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
        input [31:0] expected_quotient;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h",
                         done, quotient);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h",
                         expected_done, expected_quotient);
                $display("  Got:      done=%b, quotient=%h",
                         done, quotient);
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
        $dumpvars(0,clk, dividend, divisor, resetn, done, quotient);
    end

endmodule
