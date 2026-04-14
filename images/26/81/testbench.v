`timescale 1ns/1ps

module T_latch_tb;

    // Testbench signals (sequential circuit)
    reg E;
    reg T;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    T_latch dut (
        .E(E),
        .T(T),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        E = 0;
        forever #5 E = ~E;
    end

        task reset_dut;

    begin
        T = 0;


        @(negedge E);
        #1;
    end
        endtask
    task testcase001;

        reg initial_q;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State (T=0)", test_num);
            reset_dut();
            initial_q = Q;

            repeat(2) @(posedge E);
            #1;

            #1;


            check_outputs(initial_q);
        end
        endtask

    task testcase002;

        reg initial_q;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Toggle (T=1)", test_num);
            reset_dut();
            initial_q = Q;

            T = 1;
            @(posedge E);
            #1;
            T = 0;

            #1;


            check_outputs(~initial_q);
        end
        endtask

    task testcase003;

        reg initial_q;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Toggle (T=1 for 2 cycles)", test_num);
            reset_dut();
            initial_q = Q;

            T = 1;
            repeat(2) @(posedge E);
            #1;
            T = 0;


            #1;



            check_outputs(initial_q);
        end
        endtask

    task testcase004;

        reg toggled_q;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold State after T goes Low", test_num);
            reset_dut();


            T = 1;
            @(posedge E);
            #1;
            toggled_q = Q;


            T = 0;
            repeat(3) @(posedge E);
            #1;

            #1;


            check_outputs(toggled_q);
        end
        endtask

    task testcase005;

        reg initial_q;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Change T while E is Low", test_num);
            reset_dut();
            initial_q = Q;



            T = 1;
            #2;


            if (Q !== initial_q) $display("Note: Immediate toggle detected (Level-sensitive behavior)");

            @(posedge E);
            #1;

            #1;


            check_outputs(~initial_q);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("T_latch Testbench");
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
        $dumpvars(0,E, T, Q);
    end

endmodule
