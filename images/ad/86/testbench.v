`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire equal;
    wire greater_than;
    wire less_than;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .equal(equal),
        .greater_than(greater_than),
        .less_than(less_than)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 4'sd0;
        B = 4'sd0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'sd0; B = 4'sd0;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=0, B=0 (Expected: Equal)", test_num);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'sd7; B = 4'sd7;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=7, B=7 (Expected: Equal)", test_num);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = -4'sd8; B = -4'sd8;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=-8, B=-8 (Expected: Equal)", test_num);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'sd5; B = 4'sd2;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=5, B=2 (Expected: A > B)", test_num);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = -4'sd3; B = -4'sd6;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=-3, B=-6 (Expected: A > B)", test_num);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'sd1; B = -4'sd1;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=1, B=-1 (Expected: A > B)", test_num);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'sd2; B = 4'sd6;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=2, B=6 (Expected: A < B)", test_num);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = -4'sd7; B = -4'sd2;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=-7, B=-2 (Expected: A < B)", test_num);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = -4'sd5; B = 4'sd3;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=-5, B=3 (Expected: A < B)", test_num);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'sd7; B = -4'sd8;
        repeat(2) @(posedge clk);
        #1;
        $display("Testcase %0d: A=7, B=-8 (Expected: A > B)", test_num);
        #1;

        check_outputs(0, 1, 0);
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
        input expected_equal;
        input expected_greater_than;
        input expected_less_than;
        begin
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than) &&
                expected_less_than === (expected_less_than ^ less_than ^ expected_less_than)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater_than=%b, less_than=%b",
                         equal, greater_than, less_than);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater_than=%b, less_than=%b",
                         expected_equal, expected_greater_than, expected_less_than);
                $display("  Got:      equal=%b, greater_than=%b, less_than=%b",
                         equal, greater_than, less_than);
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
        $dumpvars(0,A, B, clk, equal, greater_than, less_than);
    end

endmodule
