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
    wire DFFOut;
    wire DLatchOut;
    wire JKOut;
    wire RSOUt;
    wire TOUt;

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
        .DFFOut(DFFOut),
        .DLatchOut(DLatchOut),
        .JKOut(JKOut),
        .RSOUt(RSOUt),
        .TOUt(TOUt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin

            D = 0;
            R = 1;
            S = 0;
            J = 0;
            K = 1;
            T = 0;


            @(posedge clk);
            #2;



            if (TOUt === 1'b1) begin
                T = 1;
                @(posedge clk);
                #2;
                T = 0;
            end


            D = 0; R = 0; S = 0; J = 0; K = 0; T = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verify all outputs are 0 after reset", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Set all outputs to 1", test_num);
            reset_dut();


            D = 1;
            S = 1; R = 0;
            J = 1; K = 0;
            T = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1, 1, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Test JK and T toggling behavior", test_num);
            reset_dut();


            J = 1; K = 1;
            T = 1;
            @(posedge clk);
            #2;



            @(posedge clk);
            #2;


            #1;



            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Test RS Latch Hold and Reset", test_num);
            reset_dut();


            S = 1; R = 0;
            #5;


            S = 0; R = 0;
            #5;


            S = 0; R = 1;
            #5;
            S = 0; R = 0;
            #5;


            #1;



            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Verify D-Latch transparency (level) vs DFF (edge)", test_num);
            reset_dut();


            wait(clk === 0);
            D = 1;
            #2;



            wait(clk === 1);
            #2;



            @(posedge clk);
            #2;


            #1;



            check_outputs(1, 1, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: JK Hold and RS interaction", test_num);
            reset_dut();


            J = 1; K = 0;
            @(posedge clk);
            #2;


            J = 0; K = 0;
            @(posedge clk);
            #2;


            S = 1; R = 0;
            #5;


            #1;



            check_outputs(0, 0, 1, 1, 0);
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
        input expected_DFFOut;
        input expected_DLatchOut;
        input expected_JKOut;
        input expected_RSOUt;
        input expected_TOUt;
        begin
            if (expected_DFFOut === (expected_DFFOut ^ DFFOut ^ expected_DFFOut) &&
                expected_DLatchOut === (expected_DLatchOut ^ DLatchOut ^ expected_DLatchOut) &&
                expected_JKOut === (expected_JKOut ^ JKOut ^ expected_JKOut) &&
                expected_RSOUt === (expected_RSOUt ^ RSOUt ^ expected_RSOUt) &&
                expected_TOUt === (expected_TOUt ^ TOUt ^ expected_TOUt)) begin
                $display("PASS");
                $display("  Outputs: DFFOut=%b, DLatchOut=%b, JKOut=%b, RSOUt=%b, TOUt=%b",
                         DFFOut, DLatchOut, JKOut, RSOUt, TOUt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DFFOut=%b, DLatchOut=%b, JKOut=%b, RSOUt=%b, TOUt=%b",
                         expected_DFFOut, expected_DLatchOut, expected_JKOut, expected_RSOUt, expected_TOUt);
                $display("  Got:      DFFOut=%b, DLatchOut=%b, JKOut=%b, RSOUt=%b, TOUt=%b",
                         DFFOut, DLatchOut, JKOut, RSOUt, TOUt);
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
        $dumpvars(0,D, J, K, R, S, T, clk, DFFOut, DLatchOut, JKOut, RSOUt, TOUt);
    end

endmodule
