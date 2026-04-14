`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] temperature;
    wire [2:0] frequency;
    wire [2:0] voltage;

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
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Temperature (0C)", test_num);
        temperature = 8'd0;
        #1;

        check_outputs(3'd3, 3'd3);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Below Threshold Boundary (29C)", test_num);
        temperature = 8'd29;
        #1;

        check_outputs(3'd3, 3'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Lower Range Boundary (30C)", test_num);
        temperature = 8'd30;
        #1;

        check_outputs(3'd2, 3'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Nominal Operating Temp (50C)", test_num);
        temperature = 8'd50;
        #1;

        check_outputs(3'd2, 3'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Upper Range Boundary (70C)", test_num);
        temperature = 8'd70;
        #1;

        check_outputs(3'd2, 3'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Above Threshold Boundary (71C)", test_num);
        temperature = 8'd71;
        #1;

        check_outputs(3'd1, 3'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High Temperature (100C)", test_num);
        temperature = 8'd100;
        #1;

        check_outputs(3'd1, 3'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Temperature (255C)", test_num);
        temperature = 8'd255;
        #1;

        check_outputs(3'd1, 3'd1);
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
        input [2:0] expected_frequency;
        input [2:0] expected_voltage;
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
