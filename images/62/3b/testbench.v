`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg s_in;
    wire s_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .s_in(s_in),
        .s_out(s_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            s_in = 0;

            repeat(10) @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1-cycle HIGH glitch", test_num);
            reset_dut();
            s_in = 1;
            @(negedge clk);
            s_in = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3-cycle HIGH pulse", test_num);
            reset_dut();
            s_in = 1;
            repeat(3) @(negedge clk);
            s_in = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stable HIGH for 4 cycles", test_num);
            reset_dut();
            s_in = 1;
            repeat(4) @(negedge clk);

            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sustained HIGH for 10 cycles", test_num);
            reset_dut();
            s_in = 1;
            repeat(10) @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: LOW glitch while HIGH", test_num);
            reset_dut();
            s_in = 1;
            repeat(6) @(negedge clk);
            s_in = 0;
            repeat(2) @(negedge clk);
            s_in = 1;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stable LOW for 4 cycles after HIGH state", test_num);
            reset_dut();
            s_in = 1;
            repeat(6) @(negedge clk);
            s_in = 0;
            repeat(4) @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fast toggling (2-cycle periods)", test_num);
            reset_dut();
            repeat(4) begin
                s_in = 1; repeat(2) @(negedge clk);
                s_in = 0; repeat(2) @(negedge clk);
            end
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge case 4-cycle HIGH then 4-cycle LOW", test_num);
            reset_dut();
            s_in = 1; repeat(4) @(negedge clk);
            s_in = 0; repeat(4) @(negedge clk);
            @(negedge clk);
            #1;

            check_outputs(1'b0);
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
        input expected_s_out;
        begin
            if (expected_s_out === (expected_s_out ^ s_out ^ expected_s_out)) begin
                $display("PASS");
                $display("  Outputs: s_out=%b",
                         s_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s_out=%b",
                         expected_s_out);
                $display("  Got:      s_out=%b",
                         s_out);
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
        $dumpvars(0,clk, s_in, s_out);
    end

endmodule
