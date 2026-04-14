`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [53:0] mantissa4;
    reg [53:0] mantissa5;
    wire expdiff;
    wire [53:0] normalized_mantissa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mantissa4(mantissa4),
        .mantissa5(mantissa5),
        .expdiff(expdiff),
        .normalized_mantissa(normalized_mantissa)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            mantissa4 <= 54'b0;
            mantissa5 <= 54'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            mantissa4 <= 54'h0;
            mantissa5 <= 54'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 54'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            mantissa4 <= 54'h20000000000000;
            mantissa5 <= 54'h1FFFFFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 54'h10000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            mantissa4 <= 54'h10000000000000;
            mantissa5 <= 54'h3FFFFFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 54'h3FFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            mantissa4 <= 54'h2AAAAAAAAAAAAA;
            mantissa5 <= 54'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 54'h15555555555555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            mantissa4 <= 54'h3FFFFFFFFFFFFF;
            mantissa5 <= 54'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 54'h1FFFFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            mantissa4 <= 54'h00000000000001;
            mantissa5 <= 54'h123456789ABCDE;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 54'h123456789ABCDE);
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
        input expected_expdiff;
        input [53:0] expected_normalized_mantissa;
        begin
            if (expected_expdiff === (expected_expdiff ^ expdiff ^ expected_expdiff) &&
                expected_normalized_mantissa === (expected_normalized_mantissa ^ normalized_mantissa ^ expected_normalized_mantissa)) begin
                $display("PASS");
                $display("  Outputs: expdiff=%b, normalized_mantissa=%h",
                         expdiff, normalized_mantissa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: expdiff=%b, normalized_mantissa=%h",
                         expected_expdiff, expected_normalized_mantissa);
                $display("  Got:      expdiff=%b, normalized_mantissa=%h",
                         expdiff, normalized_mantissa);
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
        $dumpvars(0,clk, mantissa4, mantissa5, expdiff, normalized_mantissa);
    end

endmodule
