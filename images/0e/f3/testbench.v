`timescale 1ns/1ps

module wifi_signal_strength_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_strength;
    wire strong_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_signal_strength dut (
        .signal_strength(signal_strength),
        .strong_signal(strong_signal)
    );
    task testcase001;

        begin
            test_num = 1;
            signal_strength = 5'd0;
            $display("Test %0d: signal_strength = %0d", test_num, signal_strength);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            signal_strength = 5'd10;
            $display("Test %0d: signal_strength = %0d", test_num, signal_strength);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            signal_strength = 5'd16;
            $display("Test %0d: signal_strength = %0d (Boundary Check - Low)", test_num, signal_strength);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            signal_strength = 5'd17;
            $display("Test %0d: signal_strength = %0d (Boundary Check - High)", test_num, signal_strength);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            signal_strength = 5'd25;
            $display("Test %0d: signal_strength = %0d", test_num, signal_strength);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            signal_strength = 5'd31;
            $display("Test %0d: signal_strength = %0d (Max value)", test_num, signal_strength);
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
        $display("wifi_signal_strength Testbench");
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
        input expected_strong_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_strong_signal === (expected_strong_signal ^ strong_signal ^ expected_strong_signal)) begin
                $display("PASS");
                $display("  Outputs: strong_signal=%b",
                         strong_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strong_signal=%b",
                         expected_strong_signal);
                $display("  Got:      strong_signal=%b",
                         strong_signal);
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
