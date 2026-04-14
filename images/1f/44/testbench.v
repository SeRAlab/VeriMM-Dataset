`timescale 1ns/1ps

module JK_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    reg preset;
    reg reset;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_flip_flop dut (
        .J(J),
        .K(K),
        .clk(clk),
        .preset(preset),
        .reset(reset),
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
        reset = 1;
        preset = 0;
        J = 0;
        K = 0;
        #15;
        reset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Testing Asynchronous Reset", test_num);

        preset = 1; #10;
        preset = 0; #5;

        reset = 1;
        #2;
        #1;

        check_outputs(0, 1);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Testing Asynchronous Preset", test_num);


        reset = 1; #5;
        reset = 0; #5;
        preset = 1;
        #2;
        #1;

        check_outputs(1, 0);
        preset = 0;
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Testing Synchronous Set (J=1, K=0)", test_num);
        @(negedge clk);
        J = 1;
        K = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Testing Synchronous Reset (J=0, K=1)", test_num);

        preset = 1; #10;
        preset = 0;
        @(negedge clk);
        J = 0;
        K = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Testing Synchronous Hold (J=0, K=0)", test_num);

        preset = 1; #10;
        preset = 0;
        @(negedge clk);
        J = 0;
        K = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Testing Synchronous Toggle (J=1, K=1)", test_num);

        @(negedge clk);
        J = 1;
        K = 1;
        @(posedge clk);
        #10;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Testing Async Reset Override during J=1", test_num);
        @(negedge clk);
        J = 1;
        K = 0;
        reset = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(0, 1);
        reset = 0;
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
        $dumpvars(0,J, K, clk, preset, reset, Q, Qn);
    end

endmodule
