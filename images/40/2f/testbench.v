`timescale 1ns/1ps

module JK_FF_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg J;
    reg K;
    reg Reset;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_FF dut (
        .Clock(Clock),
        .J(J),
        .K(K),
        .Reset(Reset),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            Reset = 1;
            J = 0;
            K = 0;
            @(posedge Clock);
            #1;
            Reset = 0;
            $display("Test %0d: Resetting DUT...", test_num);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            J = 1;
            K = 0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            J = 1; K = 0;
            @(posedge Clock);
            #1;

            J = 0; K = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            J = 1; K = 0;
            @(posedge Clock);
            #1;

            J = 0; K = 0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            J = 0; K = 0;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            J = 1;
            K = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            J = 1; K = 0;
            @(posedge Clock);
            #1;

            J = 1; K = 1;
            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            J = 1;
            K = 1;
            @(posedge Clock);
            #1;
            @(posedge Clock);
            #1;
            @(posedge Clock);
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
        $display("JK_FF Testbench");
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
        $dumpvars(0,Clock, J, K, Reset, Q, Qn);
    end

endmodule
