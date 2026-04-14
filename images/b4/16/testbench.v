`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
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
            d = 8'h00;
            reset = 1;
            @(posedge clk);
            @(negedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift single bit (d[0]=1)", test_num);
            reset_dut();
            d = 8'h01;
            @(negedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift sequence (1, 0, 1)", test_num);
            reset_dut();
            d = 8'h01; @(negedge clk);
            d = 8'h00; @(negedge clk);
            d = 8'h01; @(negedge clk);
            #1;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fill register with pattern 0xC5", test_num);
            reset_dut();

            d = 8'h01; @(negedge clk);
            d = 8'h00; @(negedge clk);
            d = 8'h01; @(negedge clk);
            d = 8'h00; @(negedge clk);
            d = 8'h00; @(negedge clk);
            d = 8'h00; @(negedge clk);
            d = 8'h01; @(negedge clk);
            d = 8'h01; @(negedge clk);
            #1;
            #1;

            check_outputs(8'hC5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset priority over shift", test_num);
            reset_dut();
            d = 8'h01;
            @(negedge clk);
            reset = 1;
            d = 8'h01;
            @(negedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify only d[0] is sampled", test_num);
            reset_dut();
            d = 8'hFE;
            @(negedge clk);
            d = 8'h01;
            @(negedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift bit out of register (9 cycles)", test_num);
            reset_dut();
            d = 8'h01;
            @(negedge clk);
            d = 8'h00;
            repeat(8) @(negedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d, reset, q);
    end

endmodule
