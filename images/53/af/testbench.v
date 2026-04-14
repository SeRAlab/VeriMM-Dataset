`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg J;
    reg K;
    reg S;
    wire Q;
    wire Q_bar;

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
        .S(S),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            S = 1;
            J = 0;
            K = 0;
            D = 0;
            #15;
            S = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Set (S=1)", test_num);

            S = 1;
            J = 0;
            K = 1;
            #5;
            #1;

            check_outputs(1'b1, 1'b0);
            S = 0;
            #5;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Synchronous Set (J=1, K=0)", test_num);
            reset_dut();

            @(negedge CLK);
            J = 0; K = 1;
            @(posedge CLK);
            #1;

            @(negedge CLK);
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
            $display("Testcase %0d: Synchronous Reset (J=0, K=1)", test_num);
            reset_dut();
            @(negedge CLK);
            J = 0; K = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Toggle (J=1, K=1) 1 -> 0", test_num);
            reset_dut();
            @(negedge CLK);
            J = 1; K = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Toggle (J=1, K=1) 0 -> 1", test_num);
            reset_dut();

            @(negedge CLK);
            J = 0; K = 1;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            J = 1; K = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: J=0, K=0, D=1", test_num);
            reset_dut();

            @(negedge CLK);
            J = 0; K = 1;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            J = 0; K = 0; D = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: J=0, K=0, D=0", test_num);
            reset_dut();
            @(negedge CLK);
            J = 0; K = 0; D = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Asynchronous Set Overriding Sync Reset", test_num);
            reset_dut();
            @(negedge CLK);
            J = 0; K = 1;
            S = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
            S = 0;
            #5;
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
        input expected_Q;
        input expected_Q_bar;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_bar === (expected_Q_bar ^ Q_bar ^ expected_Q_bar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_bar=%b",
                         Q, Q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_bar=%b",
                         expected_Q, expected_Q_bar);
                $display("  Got:      Q=%b, Q_bar=%b",
                         Q, Q_bar);
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
        $dumpvars(0,CLK, D, J, K, S, Q, Q_bar);
    end

endmodule
