`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg J;
    reg K;
    reg RST;
    wire Q;
    wire Q_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .J(J),
        .K(K),
        .RST(RST),
        .Q(Q),
        .Q_n(Q_n)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        J = 0;
        K = 0;
        @(posedge CLK);
        #1;
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset functionality", test_num);
        reset_dut();
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Set operation (J=1, K=0)", test_num);
        reset_dut();
        J = 1; K = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Reset operation via K (J=0, K=1)", test_num);
        reset_dut();

        J = 1; K = 0;
        @(posedge CLK);

        #1; J = 0; K = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Toggle operation 0 -> 1", test_num);
        reset_dut();
        J = 1; K = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Toggle operation 1 -> 0", test_num);
        reset_dut();

        J = 1; K = 0;
        @(posedge CLK);

        #1; J = 1; K = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Hold operation (J=0, K=0)", test_num);
        reset_dut();

        J = 1; K = 0;
        @(posedge CLK);

        #1; J = 0; K = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Reset override during J/K inputs", test_num);
        reset_dut();

        RST = 1; J = 1; K = 0;
        @(posedge CLK);
        #1;
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
        input expected_Q;
        input expected_Q_n;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_n === (expected_Q_n ^ Q_n ^ expected_Q_n)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_n=%b",
                         Q, Q_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_n=%b",
                         expected_Q, expected_Q_n);
                $display("  Got:      Q=%b, Q_n=%b",
                         Q, Q_n);
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
        $dumpvars(0,CLK, J, K, RST, Q, Q_n);
    end

endmodule
