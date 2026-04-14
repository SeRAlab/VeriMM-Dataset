`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] inputMulA;
    reg sysclock;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inputMulA(inputMulA),
        .sysclock(sysclock),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        sysclock = 0;
        forever #5 sysclock = ~sysclock;
    end

        task reset_dut;

    begin
        inputMulA = 0;
        @(posedge sysclock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        inputMulA = 32'h0;
        @(posedge sysclock);
        #1;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        inputMulA = 32'h1;
        @(posedge sysclock);
        #1;
        #1;

        check_outputs(64'h1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        inputMulA = 32'h2;
        @(posedge sysclock);
        #1;
        #1;

        check_outputs(64'h4);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        inputMulA = 32'h10000;
        @(posedge sysclock);
        #1;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        inputMulA = 32'hFFFFFFFF;
        @(posedge sysclock);
        #1;
        #1;

        check_outputs(64'hFFFFFFFE00000001);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        inputMulA = 32'd12345678;
        @(posedge sysclock);
        #1;
        #1;

        check_outputs(64'd152415765279684);
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
        input [63:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,inputMulA, sysclock, product);
    end

endmodule
