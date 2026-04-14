`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (combinational circuit)
    reg signal_A;
    reg signal_B;
    wire phase_det_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .signal_A(signal_A),
        .signal_B(signal_B),
        .phase_det_out(phase_det_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: signal_A=0, signal_B=0", test_num);
            signal_A = 0;
            signal_B = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: signal_A=1, signal_B=1", test_num);
            signal_A = 1;
            signal_B = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: signal_A=0, signal_B=1", test_num);
            signal_A = 0;
            signal_B = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: signal_A=1, signal_B=0", test_num);
            signal_A = 1;
            signal_B = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Transition 1,0 to 0,0", test_num);
            signal_A = 1; signal_B = 0;
            #5;
            signal_A = 0; signal_B = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Transition 1,1 to 1,0", test_num);
            signal_A = 1; signal_B = 1;
            #5;
            signal_A = 1; signal_B = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_detector Testbench");
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
        input expected_phase_det_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_phase_det_out === (expected_phase_det_out ^ phase_det_out ^ expected_phase_det_out)) begin
                $display("PASS");
                $display("  Outputs: phase_det_out=%b",
                         phase_det_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_det_out=%b",
                         expected_phase_det_out);
                $display("  Got:      phase_det_out=%b",
                         phase_det_out);
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

endmodule
