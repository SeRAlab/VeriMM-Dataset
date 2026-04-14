`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire hazard_detected;
    wire resolved;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .a(a),
        .b(b),
        .hazard_detected(hazard_detected),
        .resolved(resolved)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: a=0, b=0", test_num);
            a = 1'b0;
            b = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: a=0, b=1", test_num);
            a = 1'b0;
            b = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: a=1, b=0", test_num);
            a = 1'b1;
            b = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: a=1, b=1", test_num);
            a = 1'b1;
            b = 1'b1;
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
        $display("hazard_detection Testbench");
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
        input expected_hazard_detected;
        input expected_resolved;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard_detected === (expected_hazard_detected ^ hazard_detected ^ expected_hazard_detected) &&
                expected_resolved === (expected_resolved ^ resolved ^ expected_resolved)) begin
                $display("PASS");
                $display("  Outputs: hazard_detected=%b, resolved=%b",
                         hazard_detected, resolved);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard_detected=%b, resolved=%b",
                         expected_hazard_detected, expected_resolved);
                $display("  Got:      hazard_detected=%b, resolved=%b",
                         hazard_detected, resolved);
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
