`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg j;
    reg k;
    reg rst;
    reg set;
    wire q;
    wire qbar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .j(j),
        .k(k),
        .rst(rst),
        .set(set),
        .q(q),
        .qbar(qbar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        set = 0;
        j = 0;
        k = 0;
        @(posedge clk);
        #1;
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Set functionality", test_num);
        reset_dut();
        @(posedge clk);
        set = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
        set = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: JK Set (J=1, K=0)", test_num);
        reset_dut();
        j = 1;
        k = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: JK Reset (J=0, K=1)", test_num);
        reset_dut();

        j = 1; k = 0;
        @(posedge clk);

        j = 0; k = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: JK Hold (J=0, K=0)", test_num);
        reset_dut();

        j = 1; k = 0;
        @(posedge clk);

        j = 0; k = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: JK Toggle (0 -> 1)", test_num);
        reset_dut();
        j = 1; k = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: JK Toggle (1 -> 0)", test_num);
        reset_dut();
        j = 1; k = 0; @(posedge clk);
        j = 1; k = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Reset over Set", test_num);
        reset_dut();
        rst = 1;
        set = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
        rst = 0; set = 0;
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Set over J/K", test_num);
        reset_dut();
        set = 1;
        j = 0; k = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
        set = 0;
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Toggles", test_num);
        reset_dut();
        j = 1; k = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_qbar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qbar === (expected_qbar ^ qbar ^ expected_qbar)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qbar=%b",
                         q, qbar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qbar=%b",
                         expected_q, expected_qbar);
                $display("  Got:      q=%b, qbar=%b",
                         q, qbar);
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
        $dumpvars(0,clk, j, k, rst, set, q, qbar);
    end

endmodule
