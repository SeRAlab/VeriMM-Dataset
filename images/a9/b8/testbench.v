`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg J;
    reg K;
    reg R;
    reg S;
    reg T;
    reg clk;
    wire QD;
    wire QJK;
    wire QSR;
    wire QT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .J(J),
        .K(K),
        .R(R),
        .S(S),
        .T(T),
        .clk(clk),
        .QD(QD),
        .QJK(QJK),
        .QSR(QSR),
        .QT(QT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            D = 0;
            J = 0; K = 1;
            S = 0; R = 1;
            T = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            D = 1;
            J = 1; K = 0;
            S = 1; R = 0;
            T = 1;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Set all outputs to 1", test_num);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            D = 1; J = 1; K = 0; S = 1; R = 0; T = 1;
            @(posedge clk);
            #1;


            D = 0;
            J = 0; K = 1;
            S = 0; R = 1;
            T = 1;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Reset all outputs to 0", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            D = 1; J = 1; K = 0; S = 1; R = 0; T = 1;
            @(posedge clk);
            #1;


            D = 1;
            J = 0; K = 0;
            S = 0; R = 0;
            T = 0;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Verify Hold logic", test_num);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            J = 1; K = 1;
            T = 1;
            D = 1; S = 1; R = 0;
            @(posedge clk);
            #1;


            J = 1; K = 1;
            T = 1;
            D = 0; S = 0; R = 1;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Verify Toggle logic (JK=11, T=1)", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            D = 1; J = 1; K = 0; S = 1; R = 0; T = 0;
            @(posedge clk);
            #1;
            D = 0;
            J = 0; K = 0; S = 0; R = 0; T = 0;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Specific D and SR check", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_QD;
        input expected_QJK;
        input expected_QSR;
        input expected_QT;
        begin
            if (expected_QD === (expected_QD ^ QD ^ expected_QD) &&
                expected_QJK === (expected_QJK ^ QJK ^ expected_QJK) &&
                expected_QSR === (expected_QSR ^ QSR ^ expected_QSR) &&
                expected_QT === (expected_QT ^ QT ^ expected_QT)) begin
                $display("PASS");
                $display("  Outputs: QD=%b, QJK=%b, QSR=%b, QT=%b",
                         QD, QJK, QSR, QT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: QD=%b, QJK=%b, QSR=%b, QT=%b",
                         expected_QD, expected_QJK, expected_QSR, expected_QT);
                $display("  Got:      QD=%b, QJK=%b, QSR=%b, QT=%b",
                         QD, QJK, QSR, QT);
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
        $dumpvars(0,D, J, K, R, S, T, clk, QD, QJK, QSR, QT);
    end

endmodule
