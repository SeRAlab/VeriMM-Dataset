`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] temperature;
    reg [1:0] workload;
    wire [1:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .temperature(temperature),
        .workload(workload),
        .frequency(frequency),
        .voltage(voltage)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Low Temp, Low Workload", test_num);
        temperature = 3'b000; workload = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Low Temp, Med Workload", test_num);
        temperature = 3'b000; workload = 2'b01;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Low Temp, High Workload", test_num);
        temperature = 3'b000; workload = 2'b10;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Med Temp, Low Workload", test_num);
        temperature = 3'b001; workload = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Med Temp, Med Workload", test_num);
        temperature = 3'b001; workload = 2'b01;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Med Temp, High Workload (Thermal Throttling)", test_num);
        temperature = 3'b001; workload = 2'b10;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: High Temp, Low Workload", test_num);
        temperature = 3'b010; workload = 2'b00;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: High Temp, Med Workload (Thermal Safety)", test_num);
        temperature = 3'b010; workload = 2'b01;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: High Temp, High Workload (Critical State)", test_num);
        temperature = 3'b010; workload = 2'b10;
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
        testcase009();
        
        
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
