`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    wire in_phase;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .A(A),
        .B(B),
        .in_phase(in_phase)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both inputs 0 (In-phase)", test_num);
            A = 1'b0;
            B = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Both inputs 1 (In-phase)", test_num);
            A = 1'b1;
            B = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=0, B=1 (Out-of-phase)", test_num);
            A = 1'b0;
            B = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=1, B=0 (Out-of-phase)", test_num);
            A = 1'b1;
            B = 1'b0;
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
        input expected_in_phase;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in_phase === (expected_in_phase ^ in_phase ^ expected_in_phase)) begin
                $display("PASS");
                $display("  Outputs: in_phase=%b",
                         in_phase);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_phase=%b",
                         expected_in_phase);
                $display("  Got:      in_phase=%b",
                         in_phase);
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
