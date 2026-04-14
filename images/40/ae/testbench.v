`timescale 1ns/1ps

module fan_speed_control_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [3:0] temperature;
    wire [2:0] fan_speed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fan_speed_control dut (
        .control(control),
        .temperature(temperature),
        .fan_speed(fan_speed)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control 00 - Fan should be OFF regardless of temperature", test_num);
        control = 2'b00;
        temperature = 4'd10;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control 01 - Temperature (15) < 50, Fan should be OFF", test_num);
        control = 2'b01;
        temperature = 4'd15;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control 01 - Temperature (0) < 50, Fan should be OFF", test_num);
        control = 2'b01;
        temperature = 4'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control 10 - Fan should be MEDIUM regardless of temperature", test_num);
        control = 2'b10;
        temperature = 4'd5;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control 11 - Fan should be MEDIUM regardless of temperature", test_num);
        control = 2'b11;
        temperature = 4'd12;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control 00 - Testing boundary temperature (0)", test_num);
        control = 2'b00;
        temperature = 4'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Control 10 - Testing boundary temperature (15)", test_num);
        control = 2'b10;
        temperature = 4'd15;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Switching from Manual to Auto Mode", test_num);

        control = 2'b10;
        temperature = 4'd8;
        #5;

        control = 2'b01;
        #1;

        check_outputs(3'b000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fan_speed_control Testbench");
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
        input [2:0] expected_fan_speed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fan_speed === (expected_fan_speed ^ fan_speed ^ expected_fan_speed)) begin
                $display("PASS");
                $display("  Outputs: fan_speed=%h",
                         fan_speed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fan_speed=%h",
                         expected_fan_speed);
                $display("  Got:      fan_speed=%h",
                         fan_speed);
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
