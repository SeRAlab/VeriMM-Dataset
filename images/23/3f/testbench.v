`timescale 1ns/1ps

module JK_latch_tb;

    // Testbench signals (sequential circuit)
    reg Enable;
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
        .Enable(Enable),
        .J(J),
        .K(K),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        Enable = 0;
        forever #5 Enable = ~Enable;
    end

        task reset_dut;

        begin
            J = 0;
            K = 1;

            @(posedge Enable);
            #2;

            @(negedge Enable);
            $display("DUT Reset to Q=0, Qn=1");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Set Operation (J=1, K=0)");
            J = 1;
            K = 0;
            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Reset Operation (J=0, K=1)");

            J = 1; K = 0;
            @(posedge Enable); #2; @(negedge Enable);

            J = 0; K = 1;
            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Hold Operation (J=0, K=0)");

            J = 1; K = 0;
            @(posedge Enable); #2; @(negedge Enable);

            J = 0; K = 0;
            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Toggle Operation (0 to 1)");
            J = 1; K = 1;
            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Toggle Operation (1 to 0)");

            J = 1; K = 0;
            @(posedge Enable); #2; @(negedge Enable);

            J = 1; K = 1;
            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Enable Control (Input ignored when Enable=0)");

            @(negedge Enable);

            J = 1; K = 0;
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: Sequential logic within transparency window");
            @(posedge Enable);
            J = 1; K = 0; #2;
            J = 0; K = 1; #2;
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
        $dumpvars(0,Enable, J, K, Q, Qn);
    end

endmodule
