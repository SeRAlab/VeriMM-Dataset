`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg J;
    reg K;
    reg R;
    reg S;
    reg T;
    wire Q_D;
    wire Q_JK;
    wire Q_SR;
    wire Q_T;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .J(J),
        .K(K),
        .R(R),
        .S(S),
        .T(T),
        .Q_D(Q_D),
        .Q_JK(Q_JK),
        .Q_SR(Q_SR),
        .Q_T(Q_T)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin



            D = 0; J = 0; K = 1; T = 0; S = 0; R = 1;


            @(posedge CLK);
            @(negedge CLK);



            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initializing all to 0", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: D Flip-Flop Capture 1 (Rising Edge)", test_num);
            reset_dut();
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: JK Flip-Flop Set (J=1, K=0 on Falling Edge)", test_num);
            reset_dut();
            J = 1; K = 0;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: JK Flip-Flop Toggle (J=1, K=1 on Falling Edge)", test_num);
            reset_dut();

            J = 1; K = 0;
            @(negedge CLK);
            #2;

            J = 1; K = 1;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: T Flip-Flop Toggle (T=1 on Rising Edge)", test_num);
            reset_dut();
            T = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: SR Flip-Flop Set (S=1, R=0 on Falling Edge)", test_num);
            reset_dut();
            S = 1; R = 0;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: SR Flip-Flop Hold (S=0, R=0)", test_num);
            reset_dut();

            S = 1; R = 0;
            @(negedge CLK);
            #2;

            S = 0; R = 0;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Simultaneous check (D, T rising; JK, SR falling)", test_num);
            reset_dut();


            D = 1; T = 1;
            @(posedge CLK);
            #2;


            J = 1; K = 0; S = 1; R = 0;
            @(negedge CLK);
            #2;


            #1;



            check_outputs(1, 1, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Resetting JK and SR specifically", test_num);
            reset_dut();

            J = 1; K = 0; S = 1; R = 0;
            @(negedge CLK);
            #2;

            J = 0; K = 1; S = 0; R = 1;
            @(negedge CLK);
            #2;
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_Q_D;
        input expected_Q_JK;
        input expected_Q_SR;
        input expected_Q_T;
        begin
            if (expected_Q_D === (expected_Q_D ^ Q_D ^ expected_Q_D) &&
                expected_Q_JK === (expected_Q_JK ^ Q_JK ^ expected_Q_JK) &&
                expected_Q_SR === (expected_Q_SR ^ Q_SR ^ expected_Q_SR) &&
                expected_Q_T === (expected_Q_T ^ Q_T ^ expected_Q_T)) begin
                $display("PASS");
                $display("  Outputs: Q_D=%b, Q_JK=%b, Q_SR=%b, Q_T=%b",
                         Q_D, Q_JK, Q_SR, Q_T);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_D=%b, Q_JK=%b, Q_SR=%b, Q_T=%b",
                         expected_Q_D, expected_Q_JK, expected_Q_SR, expected_Q_T);
                $display("  Got:      Q_D=%b, Q_JK=%b, Q_SR=%b, Q_T=%b",
                         Q_D, Q_JK, Q_SR, Q_T);
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
        $dumpvars(0,CLK, D, J, K, R, S, T, Q_D, Q_JK, Q_SR, Q_T);
    end

endmodule
