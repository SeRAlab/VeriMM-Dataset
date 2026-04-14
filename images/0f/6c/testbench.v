`timescale 1ns/1ps

module JK_latch_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg J;
    reg K;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_latch dut (
        .CLK(CLK),
        .J(J),
        .K(K),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin

            J <= 0;
            K <= 1;
            @(posedge CLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Set (J=1, K=0)", test_num);
            reset_dut();
            J <= 1;
            K <= 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reset (J=0, K=1)", test_num);

            J <= 1;
            K <= 0;
            @(posedge CLK);
            #2;

            J <= 0;
            K <= 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Hold from 0 (J=0, K=0)", test_num);
            reset_dut();
            J <= 0;
            K <= 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hold from 1 (J=0, K=0)", test_num);

            J <= 1;
            K <= 0;
            @(posedge CLK);
            #2;

            J <= 0;
            K <= 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Toggle 0->1 (J=1, K=1)", test_num);
            reset_dut();
            J <= 1;
            K <= 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Toggle 1->0 (J=1, K=1)", test_num);

            J <= 1;
            K <= 0;
            @(posedge CLK);
            #2;

            J <= 1;
            K <= 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Double Toggle 0->1->0 (J=1, K=1)", test_num);
            reset_dut();
            J <= 1;
            K <= 1;
            @(posedge CLK);
            #2;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JK_latch Testbench");
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
        $dumpvars(0,CLK, J, K, Q, Qn);
    end

endmodule
