`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg reset;
    wire disc;
    wire err;
    wire flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .disc(disc),
        .err(err),
        .flag(flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            in = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence 111110 -> disc", test_num);
            reset_dut();
            repeat(5) begin
                in = 1; @(negedge clk);
            end
            in = 0; @(negedge clk);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence 1111110 -> flag", test_num);
            reset_dut();
            repeat(6) begin
                in = 1; @(negedge clk);
            end
            in = 0; @(negedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence 1111111 -> err", test_num);
            reset_dut();
            repeat(7) begin
                in = 1; @(negedge clk);
            end
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence 11110 -> no output", test_num);
            reset_dut();
            repeat(4) begin
                in = 1; @(negedge clk);
            end
            in = 0; @(negedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 10 ones -> err persistent", test_num);
            reset_dut();
            repeat(10) begin
                in = 1; @(negedge clk);
            end
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1110111110 -> disc at end", test_num);
            reset_dut();
            repeat(3) begin in = 1; @(negedge clk); end
            in = 0; @(negedge clk);
            repeat(5) begin in = 1; @(negedge clk); end
            in = 0; @(negedge clk);
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset mid-sequence", test_num);
            reset_dut();
            repeat(5) begin in = 1; @(negedge clk); end

            reset = 1; @(negedge clk);
            reset = 0; in = 0; @(negedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_disc;
        input expected_err;
        input expected_flag;
        begin
            if (expected_disc === (expected_disc ^ disc ^ expected_disc) &&
                expected_err === (expected_err ^ err ^ expected_err) &&
                expected_flag === (expected_flag ^ flag ^ expected_flag)) begin
                $display("PASS");
                $display("  Outputs: disc=%b, err=%b, flag=%b",
                         disc, err, flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: disc=%b, err=%b, flag=%b",
                         expected_disc, expected_err, expected_flag);
                $display("  Got:      disc=%b, err=%b, flag=%b",
                         disc, err, flag);
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
        $dumpvars(0,clk, in, reset, disc, err, flag);
    end

endmodule
