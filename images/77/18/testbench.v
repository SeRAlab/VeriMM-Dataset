`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CP;
    reg J;
    reg K;
    wire Q;
    wire Qnot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CP(CP),
        .J(J),
        .K(K),
        .Q(Q),
        .Qnot(Qnot)
    );

    // Clock generation (10ns period)
    initial begin
        CP = 0;
        forever #5 CP = ~CP;
    end

        task reset_dut;

    begin
        J = 0;
        K = 1;
        @(posedge CP);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Set (J=1, K=0)", test_num);

        J = 1;
        K = 0;
        @(posedge CP);
        #1;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        J = 1;
        K = 0;
        @(posedge CP);
        #1;

        test_num = test_num + 1;
        $display("Testcase %0d: Reset (J=0, K=1)", test_num);

        J = 0;
        K = 1;
        @(posedge CP);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Hold 0 (J=0, K=0)", test_num);

        J = 0;
        K = 0;
        @(posedge CP);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        J = 1;
        K = 0;
        @(posedge CP);
        #1;

        test_num = test_num + 1;
        $display("Testcase %0d: Hold 1 (J=0, K=0)", test_num);

        J = 0;
        K = 0;
        @(posedge CP);
        #1;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle 0->1 (J=1, K=1)", test_num);

        J = 1;
        K = 1;
        @(posedge CP);
        #1;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();

        J = 1;
        K = 0;
        @(posedge CP);
        #1;

        test_num = test_num + 1;
        $display("Testcase %0d: Toggle 1->0 (J=1, K=1)", test_num);

        J = 1;
        K = 1;
        @(posedge CP);
        #1;

        #1;


        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Double Toggle 0->1->0 (J=1, K=1)", test_num);

        J = 1;
        K = 1;
        @(posedge CP);
        @(posedge CP);
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
        input expected_Qnot;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qnot === (expected_Qnot ^ Qnot ^ expected_Qnot)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qnot=%b",
                         Q, Qnot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qnot=%b",
                         expected_Q, expected_Qnot);
                $display("  Got:      Q=%b, Qnot=%b",
                         Q, Qnot);
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
        $dumpvars(0,CP, J, K, Q, Qnot);
    end

endmodule
