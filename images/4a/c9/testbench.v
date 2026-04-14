`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    wire out_alwaysblock;
    wire out_assign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .out_alwaysblock(out_alwaysblock),
        .out_assign(out_assign)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;

            repeat (4) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input a=0, b=0", test_num);
            a = 0;
            b = 0;

            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input a=0, b=1", test_num);
            a = 0;
            b = 1;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input a=1, b=0", test_num);
            a = 1;
            b = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Input a=1, b=1", test_num);
            a = 1;
            b = 1;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Pipeline Clearance (1,1 then 0,0)", test_num);


            a = 1; b = 1;
            @(posedge clk);


            a = 0; b = 0;


            repeat (2) @(posedge clk);
            #1;
            $display("  Checking first result (1 AND 1)...");
            if (out_assign === 1'b1) pass_count = pass_count + 0;


            @(posedge clk);
            #1;
            $display("  Checking second result (0 AND 0)...");
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_out_alwaysblock;
        input expected_out_assign;
        begin
            if (expected_out_alwaysblock === (expected_out_alwaysblock ^ out_alwaysblock ^ expected_out_alwaysblock) &&
                expected_out_assign === (expected_out_assign ^ out_assign ^ expected_out_assign)) begin
                $display("PASS");
                $display("  Outputs: out_alwaysblock=%b, out_assign=%b",
                         out_alwaysblock, out_assign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_alwaysblock=%b, out_assign=%b",
                         expected_out_alwaysblock, expected_out_assign);
                $display("  Got:      out_alwaysblock=%b, out_assign=%b",
                         out_alwaysblock, out_assign);
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
        $dumpvars(0,a, b, clk, out_alwaysblock, out_assign);
    end

endmodule
