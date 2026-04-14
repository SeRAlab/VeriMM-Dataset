`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg reset;
    wire done;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .reset(reset),
        .done(done),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        multiplicand = 0;
        multiplier = 0;
        @(posedge clk);
        #1 reset = 0;

        @(posedge clk);
    end
        endtask
    task wait_for_done;

    begin

        repeat (20) begin
            if (done) disable wait_for_done;
            @(posedge clk);
        end
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: 12 * 10", test_num);
        reset_dut();
        multiplicand = 8'sd12;
        multiplier = 8'sd10;
        wait_for_done();
        #1;

        check_outputs(1'b1, 16'sd120);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: -12 * 10", test_num);
        reset_dut();
        multiplicand = -8'sd12;
        multiplier = 8'sd10;
        wait_for_done();
        #1;

        check_outputs(1'b1, -16'sd120);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: 12 * -10", test_num);
        reset_dut();
        multiplicand = 8'sd12;
        multiplier = -8'sd10;
        wait_for_done();
        #1;

        check_outputs(1'b1, -16'sd120);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: -12 * -10", test_num);
        reset_dut();
        multiplicand = -8'sd12;
        multiplier = -8'sd10;
        wait_for_done();
        #1;

        check_outputs(1'b1, 16'sd120);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: 0 * -50", test_num);
        reset_dut();
        multiplicand = 8'sd0;
        multiplier = -8'sd50;
        wait_for_done();
        #1;

        check_outputs(1'b1, 16'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: 127 * 127", test_num);
        reset_dut();
        multiplicand = 8'sd127;
        multiplier = 8'sd127;
        wait_for_done();
        #1;

        check_outputs(1'b1, 16'sd16129);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: -128 * 2", test_num);
        reset_dut();
        multiplicand = -8'sd128;
        multiplier = 8'sd2;
        wait_for_done();
        #1;

        check_outputs(1'b1, -16'sd256);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: -128 * -128", test_num);
        reset_dut();
        multiplicand = -8'sd128;
        multiplier = -8'sd128;
        wait_for_done();
        #1;

        check_outputs(1'b1, 16'sd16384);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: -1 * 1", test_num);
        reset_dut();
        multiplicand = -8'sd1;
        multiplier = 8'sd1;
        wait_for_done();
        #1;

        check_outputs(1'b1, -16'sd1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: 127 * -128", test_num);
        reset_dut();
        multiplicand = 8'sd127;
        multiplier = -8'sd128;
        wait_for_done();
        #1;

        check_outputs(1'b1, -16'sd16256);
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
        testcase010();
        
        
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
        input [15:0] expected_product;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: done=%b, product=%h",
                         done, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, product=%h",
                         expected_done, expected_product);
                $display("  Got:      done=%b, product=%h",
                         done, product);
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
        $dumpvars(0,clk, multiplicand, multiplier, reset, done, product);
    end

endmodule
