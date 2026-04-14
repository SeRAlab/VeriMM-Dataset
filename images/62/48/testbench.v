`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg enable;
    reg [4:0] in;
    reg reset;
    wire out_and;
    wire out_nor;
    wire out_or;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .in(in),
        .reset(reset),
        .out_and(out_and),
        .out_nor(out_nor),
        .out_or(out_or),
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
            d = 0;
            enable = 0;
            in = 5'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift 1 and Check NOR Logic", test_num);
            reset_dut();


            d = 1; enable = 1; in = 5'b00000;
            @(posedge clk);
            d = 0;
            @(posedge clk);
            d = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift 0 and Check AND/OR Logic", test_num);
            reset_dut();


            d = 0; enable = 1; in = 5'b11111;
            @(posedge clk);
            d = 1;
            @(posedge clk);
            d = 1;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Check Enable Signal Gating", test_num);
            reset_dut();


            d = 1; enable = 0; in = 5'b11111;
            @(posedge clk);
            d = 0;
            @(posedge clk);
            d = 1;
            @(posedge clk);

            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Bit Logic Check", test_num);
            reset_dut();


            d = 0; enable = 1; in = 5'b10101;
            @(posedge clk);
            d = 1;
            @(posedge clk);
            d = 0;
            @(posedge clk);

            #1;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Verification", test_num);
            reset_dut();


            d = 1; enable = 1; in = 5'b00000;
            @(posedge clk);
            d = 1;
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
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
        input expected_out_and;
        input expected_out_nor;
        input expected_out_or;
        input expected_q;
        begin
            if (expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out_and=%b, out_nor=%b, out_or=%b, q=%b",
                         out_and, out_nor, out_or, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_and=%b, out_nor=%b, out_or=%b, q=%b",
                         expected_out_and, expected_out_nor, expected_out_or, expected_q);
                $display("  Got:      out_and=%b, out_nor=%b, out_or=%b, q=%b",
                         out_and, out_nor, out_or, q);
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
        $dumpvars(0,clk, d, enable, in, reset, out_and, out_nor, out_or, q);
    end

endmodule
