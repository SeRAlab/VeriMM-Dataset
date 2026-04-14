`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current;
    wire exceeds_threshold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .current(current),
        .exceeds_threshold(exceeds_threshold)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input current = 0 (Minimum value)", test_num);
        current = 4'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input current = 5 (Below threshold)", test_num);
        current = 4'd5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input current = 8 (At threshold boundary)", test_num);
        current = 4'd8;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input current = 9 (Just above threshold)", test_num);
        current = 4'd9;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input current = 12 (Random high value)", test_num);
        current = 4'd12;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input current = 15 (Maximum value)", test_num);
        current = 4'd15;
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
        $display("current_sensor Testbench");
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
        input expected_exceeds_threshold;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exceeds_threshold === (expected_exceeds_threshold ^ exceeds_threshold ^ expected_exceeds_threshold)) begin
                $display("PASS");
                $display("  Outputs: exceeds_threshold=%b",
                         exceeds_threshold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exceeds_threshold=%b",
                         expected_exceeds_threshold);
                $display("  Got:      exceeds_threshold=%b",
                         exceeds_threshold);
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
