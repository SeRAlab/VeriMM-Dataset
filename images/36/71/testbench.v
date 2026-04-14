`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_load;
    reg [7:0] desired_frequency;
    reg [7:0] desired_voltage;
    wire [7:0] adjusted_frequency;
    wire [7:0] adjusted_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .current_load(current_load),
        .desired_frequency(desired_frequency),
        .desired_voltage(desired_voltage),
        .adjusted_frequency(adjusted_frequency),
        .adjusted_voltage(adjusted_voltage)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: High Load scenario (Load > 128)", test_num);

        current_load = 8'd200;
        desired_voltage = 8'd100;
        desired_frequency = 8'd150;

        #1;


        check_outputs(8'd149, 8'd99);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Low Load scenario (Load <= 128)", test_num);

        current_load = 8'd50;
        desired_voltage = 8'd100;
        desired_frequency = 8'd150;

        #1;


        check_outputs(8'd151, 8'd101);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Upper Threshold Boundary (Load = 129)", test_num);
        current_load = 8'd129;
        desired_voltage = 8'd50;
        desired_frequency = 8'd50;

        #1;


        check_outputs(8'd49, 8'd49);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Lower Threshold Boundary (Load = 128)", test_num);
        current_load = 8'd128;
        desired_voltage = 8'd50;
        desired_frequency = 8'd50;

        #1;


        check_outputs(8'd51, 8'd51);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Maximum Load", test_num);
        current_load = 8'hFF;
        desired_voltage = 8'h80;
        desired_frequency = 8'h80;

        #1;


        check_outputs(8'h7F, 8'h7F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Zero Load", test_num);
        current_load = 8'h00;
        desired_voltage = 8'h10;
        desired_frequency = 8'h10;

        #1;


        check_outputs(8'h11, 8'h11);
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
        input [7:0] expected_adjusted_frequency;
        input [7:0] expected_adjusted_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adjusted_frequency === (expected_adjusted_frequency ^ adjusted_frequency ^ expected_adjusted_frequency) &&
                expected_adjusted_voltage === (expected_adjusted_voltage ^ adjusted_voltage ^ expected_adjusted_voltage)) begin
                $display("PASS");
                $display("  Outputs: adjusted_frequency=%h, adjusted_voltage=%h",
                         adjusted_frequency, adjusted_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adjusted_frequency=%h, adjusted_voltage=%h",
                         expected_adjusted_frequency, expected_adjusted_voltage);
                $display("  Got:      adjusted_frequency=%h, adjusted_voltage=%h",
                         adjusted_frequency, adjusted_voltage);
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
