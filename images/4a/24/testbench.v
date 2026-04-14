`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr_n;
    reg j;
    reg k;
    wire q;
    wire q_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr_n(clr_n),
        .j(j),
        .k(k),
        .q(q),
        .q_n(q_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        j = 0;
        k = 0;
        clr_n = 1;
        #2;
        clr_n = 0;
        #10;
        clr_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %0d: Asynchronous Reset Verification", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        j = 1;
        k = 0;
        @(negedge clk);
        #2;
        $display("Test %0d: J=1, K=0 (Set Operation)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        j = 1; k = 0;
        @(negedge clk);

        j = 0; k = 1;
        @(negedge clk);
        #2;
        $display("Test %0d: J=0, K=1 (Reset Operation)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        j = 1; k = 0;
        @(negedge clk);

        j = 0; k = 0;
        @(negedge clk);
        #2;
        $display("Test %0d: J=0, K=0 (Hold Operation)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        j = 1; k = 1;
        @(negedge clk);
        #2;
        $display("Test %0d: J=1, K=1 (Toggle 0 to 1)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        j = 1; k = 0;
        @(negedge clk);

        j = 1; k = 1;
        @(negedge clk);
        #2;
        $display("Test %0d: J=1, K=1 (Toggle 1 to 0)", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        j = 1; k = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        #2;
        $display("Test %0d: Triple Toggle (0 -> 1 -> 0 -> 1)", test_num);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();

        j = 1; k = 0;
        @(negedge clk);
        #2;

        clr_n = 0;
        #1;
        $display("Test %0d: Asynchronous Reset overriding state", test_num);
        #1;

        check_outputs(1'b0, 1'b1);
        clr_n = 1;
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
        input expected_q;
        input expected_q_n;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_n === (expected_q_n ^ q_n ^ expected_q_n)) begin
                $display("PASS");
                $display("  Outputs: q=%b, q_n=%b",
                         q, q_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, q_n=%b",
                         expected_q, expected_q_n);
                $display("  Got:      q=%b, q_n=%b",
                         q, q_n);
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
        $dumpvars(0,clk, clr_n, j, k, q, q_n);
    end

endmodule
