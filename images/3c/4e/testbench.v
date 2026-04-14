`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_voltage;
    wire current_exceeds_threshold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .current_voltage(current_voltage),
        .current_exceeds_threshold(current_exceeds_threshold)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Minimum Current (0 mA)", test_num);
            current_voltage = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Just below threshold (99 mA)", test_num);
            current_voltage = 8'd99;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: At threshold (100 mA)", test_num);
            current_voltage = 8'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Just above threshold (101 mA)", test_num);
            current_voltage = 8'd101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: High Current (150 mA)", test_num);
            current_voltage = 8'd150;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Maximum Input (255 mA)", test_num);
            current_voltage = 8'd255;
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
        input expected_current_exceeds_threshold;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_current_exceeds_threshold === (expected_current_exceeds_threshold ^ current_exceeds_threshold ^ expected_current_exceeds_threshold)) begin
                $display("PASS");
                $display("  Outputs: current_exceeds_threshold=%b",
                         current_exceeds_threshold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_exceeds_threshold=%b",
                         expected_current_exceeds_threshold);
                $display("  Got:      current_exceeds_threshold=%b",
                         current_exceeds_threshold);
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
