`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg CE;
    reg D1;
    reg D2;
    reg R;
    reg S;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CE(CE),
        .D1(D1),
        .D2(D2),
        .R(R),
        .S(S),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

    begin
        C = 0;
        CE = 0;
        R = 0;
        S = 0;
        D1 = 0;
        D2 = 0;
        #10;

        CE = 1;
        R = 1;
        @(posedge C);
        #2;
        R = 0;
        CE = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        CE = 1;
        R = 1;
        S = 1;
        D2 = 1;
        @(posedge C);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        CE = 1;
        R = 0;
        S = 1;
        D2 = 0;
        @(posedge C);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        CE = 1;
        R = 0;
        S = 0;
        D2 = 1;
        @(posedge C);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;

        CE = 1; S = 1; @(posedge C);
        #1;
        CE = 1;
        R = 0;
        S = 0;
        D2 = 0;
        @(posedge C);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        CE = 1;
        D1 = 1;
        @(negedge C);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;

        CE = 1; S = 1; @(posedge C);
        #1;

        CE = 1;
        D1 = 0;
        @(negedge C);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;

        CE = 1; S = 1; @(posedge C);
        #1;

        CE = 0;
        R = 1; S = 1; D1 = 0; D2 = 0;
        @(negedge C);
        #1;
        @(posedge C);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;

        CE = 1; R = 1; @(posedge C);
        #1;

        CE = 1;
        R = 1;
        S = 1;
        D1 = 1;
        @(negedge C);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        CE = 1;
        R = 1;
        S = 1;
        D2 = 1;
        @(posedge C);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        CE = 1;
        R = 0;
        S = 1;
        D2 = 0;
        @(posedge C);
        #1;
        #1;

        check_outputs(1'b1);
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
        testcase010();
        
        
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
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,C, CE, D1, D2, R, S, Q);
    end

endmodule
