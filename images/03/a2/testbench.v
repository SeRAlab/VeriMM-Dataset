`timescale 1ns/1ps

module voltage_level_detector_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] voltage;
    wire level_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_level_detector dut (
        .voltage(voltage),
        .level_detected(level_detected)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Voltage = 0", test_num);
            voltage = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Voltage = 7", test_num);
            voltage = 4'd7;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Voltage = 8", test_num);
            voltage = 4'd8;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Voltage = 9", test_num);
            voltage = 4'd9;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Voltage = 12", test_num);
            voltage = 4'd12;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Voltage = 15", test_num);
            voltage = 4'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Voltage = 4", test_num);
            voltage = 4'd4;
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
        $display("voltage_level_detector Testbench");
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
        input expected_level_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_level_detected === (expected_level_detected ^ level_detected ^ expected_level_detected)) begin
                $display("PASS");
                $display("  Outputs: level_detected=%b",
                         level_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: level_detected=%b",
                         expected_level_detected);
                $display("  Got:      level_detected=%b",
                         level_detected);
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
