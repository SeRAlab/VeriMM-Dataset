`timescale 1ns/1ps

module phase_detector_tb;

    // Testbench signals (combinational circuit)
    reg signal_a;
    reg signal_b;
    wire [1:0] phase_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_detector dut (
        .signal_a(signal_a),
        .signal_b(signal_b),
        .phase_out(phase_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Both signals LOW - Expect Equal (00)", test_num);
        signal_a = 1'b0;
        signal_b = 1'b0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Signal A leading - Expect A Leading (01)", test_num);
        signal_a = 1'b1;
        signal_b = 1'b0;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Both signals HIGH - Expect Equal (00)", test_num);
        signal_a = 1'b1;
        signal_b = 1'b1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Signal B leading (A lagging) - Expect A Lagging (10)", test_num);
        signal_a = 1'b0;
        signal_b = 1'b1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Transition from Lagging to Equal - Expect Equal (00)", test_num);

        signal_a = 1'b0;
        signal_b = 1'b1;
        #5;

        signal_a = 1'b1;
        signal_b = 1'b1;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Transition from Leading to Equal - Expect Equal (00)", test_num);

        signal_a = 1'b1;
        signal_b = 1'b0;
        #5;

        signal_a = 1'b0;
        signal_b = 1'b0;
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_phase_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_phase_out === (expected_phase_out ^ phase_out ^ expected_phase_out)) begin
                $display("PASS");
                $display("  Outputs: phase_out=%h",
                         phase_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: phase_out=%h",
                         expected_phase_out);
                $display("  Got:      phase_out=%h",
                         phase_out);
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
