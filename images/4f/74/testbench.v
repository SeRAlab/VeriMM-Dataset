`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AD;
    reg C;
    reg D;
    reg E;
    reg L;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AD(AD),
        .C(C),
        .D(D),
        .E(E),
        .L(L),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

    begin
        @(negedge C);
        L = 1;
        AD = 0;
        D = 0;
        E = 0;
        @(negedge C);
        L = 0;
        AD = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Load High (L=1, AD=1)", test_num);
        reset_dut();
        @(negedge C);
        L = 1;
        AD = 1;
        @(posedge C);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Load Low (L=1, AD=0)", test_num);

        @(negedge C);
        L = 1; AD = 1;
        @(negedge C);
        L = 1; AD = 0;
        @(posedge C);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clock Enable (E=1, D=1)", test_num);
        reset_dut();
        @(negedge C);
        L = 0;
        E = 1;
        D = 1;
        @(posedge C);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clock Enable (E=1, D=0)", test_num);

        @(negedge C);
        L = 1; AD = 1;
        @(negedge C);
        L = 0; E = 1; D = 0;
        @(posedge C);
        #2;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable Disabled (E=0) - Hold Value", test_num);

        @(negedge C);
        L = 1; AD = 1;
        @(negedge C);
        L = 0;
        E = 0;
        D = 0;
        @(posedge C);
        #2;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Priority (L=1 vs E=1)", test_num);
        reset_dut();
        @(negedge C);
        L = 1;
        AD = 1;
        E = 1;
        D = 0;

        @(posedge C);
        #2;
        #1;

        check_outputs(1);
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
        $dumpvars(0,AD, C, D, E, L, Q);
    end

endmodule
