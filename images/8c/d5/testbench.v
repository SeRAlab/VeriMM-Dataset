`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fastclk;
    reg reset_l;
    wire out_clk;
    wire out_fastclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fastclk(fastclk),
        .reset_l(reset_l),
        .out_clk(out_clk),
        .out_fastclk(out_fastclk)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_l = 0;
            @(posedge clk);
            #1;
            reset_l = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_l = 0;
            #15;

            #1;


            check_outputs(clk, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify out_clk follows clk", test_num);
            reset_dut();
            #12;

            #1;


            check_outputs(clk, out_fastclk);
        end
        endtask

    task testcase003;

        reg sampled_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify out_fastclk registers fastclk (High)", test_num);
            reset_dut();




            @(posedge clk);
            sampled_val = fastclk;
            #1;
            #1;

            check_outputs(clk, sampled_val);
        end
        endtask

    task testcase004;

        reg sampled_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify out_fastclk registers fastclk (Low)", test_num);
            reset_dut();


            repeat(3) @(posedge clk);
            sampled_val = fastclk;
            #1;
            #1;

            check_outputs(clk, sampled_val);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset Overrides Output", test_num);
            reset_dut();


            wait(out_fastclk == 1'b1);

            #2;
            reset_l = 0;
            #1;
            #1;

            check_outputs(clk, 1'b0);
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
        input expected_out_clk;
        input expected_out_fastclk;
        begin
            if (expected_out_clk === (expected_out_clk ^ out_clk ^ expected_out_clk) &&
                expected_out_fastclk === (expected_out_fastclk ^ out_fastclk ^ expected_out_fastclk)) begin
                $display("PASS");
                $display("  Outputs: out_clk=%b, out_fastclk=%b",
                         out_clk, out_fastclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_clk=%b, out_fastclk=%b",
                         expected_out_clk, expected_out_fastclk);
                $display("  Got:      out_clk=%b, out_fastclk=%b",
                         out_clk, out_fastclk);
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
        $dumpvars(0,clk, fastclk, reset_l, out_clk, out_fastclk);
    end

endmodule
