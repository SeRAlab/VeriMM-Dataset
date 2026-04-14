`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] workload;
    wire [2:0] frequency_level;
    wire [3:0] voltage_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .workload(workload),
        .frequency_level(frequency_level),
        .voltage_level(voltage_level)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase001: Workload = 000");
        workload = 3'b000;
        #1;

        check_outputs(3'd0, 4'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase002: Workload = 001");
        workload = 3'b001;
        #1;

        check_outputs(3'd1, 4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase003: Workload = 010");
        workload = 3'b010;
        #1;

        check_outputs(3'd2, 4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase004: Workload = 011");
        workload = 3'b011;
        #1;

        check_outputs(3'd3, 4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running testcase005: Workload = 100");
        workload = 3'b100;
        #1;

        check_outputs(3'd4, 4'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running testcase006: Workload = 101");
        workload = 3'b101;
        #1;

        check_outputs(3'd5, 4'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running testcase007: Workload = 110");
        workload = 3'b110;
        #1;

        check_outputs(3'd6, 4'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running testcase008: Workload = 111");
        workload = 3'b111;
        #1;

        check_outputs(3'd7, 4'd8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS_Controller Testbench");
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
        input [2:0] expected_frequency_level;
        input [3:0] expected_voltage_level;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frequency_level === (expected_frequency_level ^ frequency_level ^ expected_frequency_level) &&
                expected_voltage_level === (expected_voltage_level ^ voltage_level ^ expected_voltage_level)) begin
                $display("PASS");
                $display("  Outputs: frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_level=%h, voltage_level=%h",
                         expected_frequency_level, expected_voltage_level);
                $display("  Got:      frequency_level=%h, voltage_level=%h",
                         frequency_level, voltage_level);
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
