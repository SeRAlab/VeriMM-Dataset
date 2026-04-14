`timescale 1ns/1ps

module JK_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg J;
    reg K;
    reg Reset;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_flip_flop dut (
        .Clock(Clock),
        .J(J),
        .K(K),
        .Reset(Reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            J = 0;
            K = 0;
            @(posedge Clock);
            #1;
            Reset = 0;
            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Set Operation (J=1, K=0)", test_num);
            reset_dut();
            @(negedge Clock);
            J = 1; K = 0;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Reset Operation (J=0, K=1)", test_num);
            reset_dut();

            @(negedge Clock);
            J = 1; K = 0;
            @(posedge Clock);

            @(negedge Clock);
            J = 0; K = 1;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Hold 0 (J=0, K=0)", test_num);
            reset_dut();
            @(negedge Clock);
            J = 0; K = 0;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Hold 1 (J=0, K=0)", test_num);
            reset_dut();

            @(negedge Clock);
            J = 1; K = 0;
            @(posedge Clock);

            @(negedge Clock);
            J = 0; K = 0;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Toggle from 0 (J=1, K=1)", test_num);
            reset_dut();
            @(negedge Clock);
            J = 1; K = 1;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Toggle from 1 (J=1, K=1)", test_num);
            reset_dut();

            @(negedge Clock);
            J = 1; K = 0;
            @(posedge Clock);

            @(negedge Clock);
            J = 1; K = 1;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Double Toggle (J=1, K=1)", test_num);
            reset_dut();
            @(negedge Clock);
            J = 1; K = 1;
            @(posedge Clock);
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Reset Priority", test_num);
            reset_dut();
            @(negedge Clock);
            Reset = 1;
            J = 1; K = 0;
            @(posedge Clock);
            #2;
            #1;

            check_outputs(1'b0);
            Reset = 0;
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
        testcase008();
        testcase009();
        
        
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
        $dumpvars(0,Clock, J, K, Reset, Q);
    end

endmodule
