`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg reset;
    wire [31:0] out;

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
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Accumulation (10 * 5)", test_num);
            reset_dut();
            a = 32'd10;
            b = 32'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Accumulations (2*3 + 4*5 + 1*1)", test_num);
            reset_dut();

            a = 32'd2; b = 32'd3; @(posedge clk);
            #1;
            a = 32'd4; b = 32'd5; @(posedge clk);
            #1;
            a = 32'd1; b = 32'd1; @(posedge clk);
            #1;

            #1;


            check_outputs(32'd27);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiply by Zero", test_num);
            reset_dut();

            a = 32'd100; b = 32'd10; @(posedge clk);
            #1;
            a = 32'd50;  b = 32'd0;  @(posedge clk);
            #1;
            a = 32'd0;   b = 32'd25; @(posedge clk);
            #1;

            #1;


            check_outputs(32'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 32-bit Wrap-around", test_num);
            reset_dut();


            a = 32'hFFFFFFFF; b = 32'd1; @(posedge clk);
            #1;

            a = 32'd1; b = 32'd1; @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();

            a = 32'd5; b = 32'd5; @(posedge clk);
            #1;
            reset = 1; @(posedge clk);
            #1;
            reset = 0;
            a = 32'd3; b = 32'd3; @(posedge clk);
            #1;

            #1;


            check_outputs(32'd9);
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
        $dumpvars(0,a, b, clk, reset, out);
    end

endmodule
