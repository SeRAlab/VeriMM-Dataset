`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] temp_input;
    wire safe_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .temp_input(temp_input),
        .safe_output(safe_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Minimum value (0)", test_num);
        temp_input = 4'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Maximum 4-bit value (15)", test_num);
        temp_input = 4'd15;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Mid-range value (7)", test_num);
        temp_input = 4'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Mid-range value (8)", test_num);
        temp_input = 4'd8;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Boundary value (1)", test_num);
        temp_input = 4'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Boundary value (14)", test_num);
        temp_input = 4'd14;
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
        $display("temperature_sensor Testbench");
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
        input expected_safe_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_safe_output === (expected_safe_output ^ safe_output ^ expected_safe_output)) begin
                $display("PASS");
                $display("  Outputs: safe_output=%b",
                         safe_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: safe_output=%b",
                         expected_safe_output);
                $display("  Got:      safe_output=%b",
                         safe_output);
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
