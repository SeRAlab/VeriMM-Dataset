`timescale 1ns/1ps

module SR_latch_tb;

    // Testbench signals (sequential circuit)
    reg R;
    reg S;
    reg clk;
    wire Q;
    wire Q_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SR_latch dut (
        .R(R),
        .S(S),
        .clk(clk),
        .Q(Q),
        .Q_n(Q_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin


        S = 0;
        R = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Set (S=1, R=0)", test_num);
        reset_dut();
        S = 1;
        R = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Reset (S=0, R=1)", test_num);
        reset_dut();

        S = 1; R = 0;
        @(posedge clk);

        S = 0; R = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Hold (S=0, R=0) from Q=0", test_num);
        reset_dut();
        S = 0;
        R = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing Hold (S=0, R=0) from Q=1", test_num);
        reset_dut();

        S = 1; R = 0;
        @(posedge clk);

        S = 0; R = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing S=1, R=1 (Maintain) from Q=0", test_num);
        reset_dut();
        S = 1;
        R = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing S=1, R=1 (Maintain) from Q=1", test_num);
        reset_dut();

        S = 1; R = 0;
        @(posedge clk);

        S = 1; R = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Testing consecutive transitions Set -> Reset -> Set", test_num);
        reset_dut();

        S = 1; R = 0; @(posedge clk);
        S = 0; R = 1; @(posedge clk);
        S = 1; R = 0; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SR_latch Testbench");
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
        $dumpvars(0,R, S, clk, Q, Q_n);
    end

endmodule
