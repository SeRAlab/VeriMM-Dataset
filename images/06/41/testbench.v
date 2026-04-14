`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] temperature;
    wire [1:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .temperature(temperature),
        .frequency(frequency),
        .voltage(voltage)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Coldest temperature (0)", test_num);
            temperature = 4'd0;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Range 1 Upper Boundary (3)", test_num);
            temperature = 4'd3;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Range 2 Lower Boundary (4)", test_num);
            temperature = 4'd4;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Range 2 Midpoint (6)", test_num);
            temperature = 4'd6;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Range 3 Lower Boundary (8)", test_num);
            temperature = 4'd8;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Range 3 Upper Boundary (11)", test_num);
            temperature = 4'd11;
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Critical Temp Lower Boundary (12)", test_num);
            temperature = 4'd12;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Maximum Temperature (15)", test_num);
            temperature = 4'd15;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [1:0] expected_frequency;
        input [1:0] expected_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
