`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg clk;
    wire V;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .clk(clk),
        .V(V),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 0; B = 0; C = 0; D = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Input A active (Highest)", test_num);
        A = 1; B = 0; C = 0; D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Input B active (A inactive)", test_num);
        A = 0; B = 1; C = 0; D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Input C active (A, B inactive)", test_num);
        A = 0; B = 0; C = 1; D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b01);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Input D active (A, B, C inactive)", test_num);
        A = 0; B = 0; C = 0; D = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Overlap A and B (A should win)", test_num);
        A = 1; B = 1; C = 0; D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Overlap B, C, D (B should win)", test_num);
        A = 0; B = 1; C = 1; D = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Hold Behavior after input A", test_num);

        A = 1; B = 0; C = 0; D = 0;
        @(posedge clk);
        #1;

        A = 0; B = 0; C = 0; D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Hold Behavior after input D", test_num);

        A = 0; B = 0; C = 0; D = 1;
        @(posedge clk);
        #1;

        A = 0; B = 0; C = 0; D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Transition from C to A", test_num);

        A = 0; B = 0; C = 1; D = 0;
        @(posedge clk);
        #1;

        A = 1; B = 0; C = 0; D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 2'b11);
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
        input expected_V;
        input [1:0] expected_Y;
        begin
            if (expected_V === (expected_V ^ V ^ expected_V) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: V=%b, Y=%h",
                         V, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V=%b, Y=%h",
                         expected_V, expected_Y);
                $display("  Got:      V=%b, Y=%h",
                         V, Y);
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
        $dumpvars(0,A, B, C, D, clk, V, Y);
    end

endmodule
