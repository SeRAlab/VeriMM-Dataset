`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] performance_level;
    wire [3:0] frequency;
    wire [3:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .performance_level(performance_level),
        .frequency(frequency),
        .voltage(voltage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d...", test_num);
            performance_level = 2'b00;
            #1;

            check_outputs(4'd1, 4'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d...", test_num);
            performance_level = 2'b01;
            #1;

            check_outputs(4'd2, 4'd12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d...", test_num);
            performance_level = 2'b10;
            #1;

            check_outputs(4'd3, 4'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d...", test_num);
            performance_level = 2'b11;
            #1;

            check_outputs(4'd4, 4'd16);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase%03d (Transition)...", test_num);
            performance_level = 2'b11;
            #5;
            performance_level = 2'b00;
            #1;

            check_outputs(4'd1, 4'd10);
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
        input [3:0] expected_frequency;
        input [3:0] expected_voltage;
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
