`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [19:0] b;
    reg [19:0] c;
    reg clk;
    reg [19:0] d;
    reg reset;
    wire [19:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            b = 0;
            c = 0;
            d = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            b = 20'hFFFFF;
            c = 20'hFFFFF;
            d = 20'hFFFFF;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'hFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            b = 20'h00000;
            c = 20'h00000;
            d = 20'h00000;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Pattern", test_num);
            reset_dut();
            b = 20'hAAAAA;
            c = 20'hAAAAA;
            d = 20'hAAAAA;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'hAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Overlap", test_num);
            reset_dut();
            b = 20'hF0F0F;
            c = 20'h0F0F0;
            d = 20'hFFFFF;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random-like Bits", test_num);
            reset_dut();
            b = 20'h12345;
            c = 20'h6789A;
            d = 20'h33333;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(20'h12345 & 20'h6789A & 20'h33333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline Stability", test_num);
            reset_dut();


            b = 20'hFFFFF;
            c = 20'hFFFFF;
            d = 20'hFFFFF;
            @(posedge clk);


            b = 20'h00000;
            c = 20'h00000;
            d = 20'h00000;
            @(posedge clk);


            @(posedge clk);

            #1;

            #1;


            check_outputs(20'hFFFFF);
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
        input [19:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,b, c, clk, d, reset, q);
    end

endmodule
