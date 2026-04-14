`timescale 1ns/1ps

module counter11bit_term_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [10:0] count;
    wire term_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter11bit_term dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .count(count),
        .term_count(term_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            en = 0;
            @(negedge clk);
            rst = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(11'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Increment (10 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd10, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Signal Gating", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(11'd5, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Terminal Count Check (at 2047)", test_num);
            reset_dut();
            en = 1;
            repeat(2047) @(posedge clk);
            #1;

            #1;


            check_outputs(11'h7FF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counter Wrap-around", test_num);
            reset_dut();
            en = 1;
            repeat(2048) @(posedge clk);
            #1;

            #1;


            check_outputs(11'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Mid-Count", test_num);
            reset_dut();
            en = 1;
            repeat(100) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;

            check_outputs(11'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Toggle Enable near Max Value", test_num);
            reset_dut();
            en = 1;
            repeat(2046) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(11'h7FF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter11bit_term Testbench");
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
        input [10:0] expected_count;
        input expected_term_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_term_count === (expected_term_count ^ term_count ^ expected_term_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h, term_count=%b",
                         count, term_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, term_count=%b",
                         expected_count, expected_term_count);
                $display("  Got:      count=%h, term_count=%b",
                         count, term_count);
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
        $dumpvars(0,clk, en, rst, count, term_count);
    end

endmodule
