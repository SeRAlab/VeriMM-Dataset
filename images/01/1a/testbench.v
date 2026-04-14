`timescale 1ns/1ps

module jk_latch_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jk_latch dut (
        .J(J),
        .K(K),
        .clk(clk),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        J = 0;
        K = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Set (J=1, K=0)", test_num);
        J = 1;
        K = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        J = 1; K = 0; @(posedge clk); #1;

        test_num = test_num + 1;
        $display("Test %0d: Reset (J=0, K=1) from Q=1", test_num);
        J = 0;
        K = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();

        J = 1; K = 0; @(posedge clk); #1;

        test_num = test_num + 1;
        $display("Test %0d: Hold (J=0, K=0) from Q=1", test_num);
        J = 0;
        K = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Hold (J=0, K=0) from Q=0", test_num);
        J = 0;
        K = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Toggle (J=1, K=1) from Q=0", test_num);
        J = 1;
        K = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Toggle (J=1, K=1) twice", test_num);
        J = 1;
        K = 1;
        @(posedge clk);
        #2;
        @(posedge clk);
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
        $display("jk_latch Testbench");
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
        input expected_Qn;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qn === (expected_Qn ^ Qn ^ expected_Qn)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qn=%b",
                         Q, Qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qn=%b",
                         expected_Q, expected_Qn);
                $display("  Got:      Q=%b, Qn=%b",
                         Q, Qn);
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
        $dumpvars(0,J, K, clk, Q, Qn);
    end

endmodule
