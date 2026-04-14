`timescale 1ns/1ps

module JK_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clear;
    reg clk;
    reg preset;
    wire Q;
    wire QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_flip_flop dut (
        .J(J),
        .K(K),
        .clear(clear),
        .clk(clk),
        .preset(preset),
        .Q(Q),
        .QN(QN)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

    begin
        J = 0;
        K = 0;
        preset = 0;
        clear = 1;
        #12;
        clear = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Asynchronous Clear", test_num);
        reset_dut();

        J = 1; K = 0; clear = 1; preset = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Asynchronous Preset", test_num);
        reset_dut();
        clear = 0; preset = 1;
        #5;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: JK Set (J=1, K=0)", test_num);
        reset_dut();
        @(posedge clk);
        J = 1; K = 0; clear = 0; preset = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: JK Reset (J=0, K=1)", test_num);
        reset_dut();

        @(posedge clk);
        J = 1; K = 0;
        @(posedge clk);

        J = 0; K = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: JK Hold (J=0, K=0)", test_num);
        reset_dut();

        @(posedge clk);
        J = 1; K = 0;
        @(posedge clk);

        J = 0; K = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: JK Toggle (J=1, K=1)", test_num);
        reset_dut();
        @(posedge clk);
        J = 1; K = 1;
        @(posedge clk);
        #1;

        if (Q !== 1'b1) $display("Toggle Mid-point Fail");
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JK_flip_flop Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_Q;
        input expected_QN;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, QN=%b",
                         Q, QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, QN=%b",
                         expected_Q, expected_QN);
                $display("  Got:      Q=%b, QN=%b",
                         Q, QN);
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
        $dumpvars(0,J, K, clear, clk, preset, Q, QN);
    end

endmodule
