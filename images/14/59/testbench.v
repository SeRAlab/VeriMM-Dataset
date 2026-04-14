`timescale 1ns/1ps

module temperature_sensor_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] temperature;
    wire [2:0] warning_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor_controller dut (
        .temperature(temperature),
        .warning_level(warning_level)
    );
    task testcase001;

    begin
        test_num = 1;
        temperature = 4'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        temperature = 4'd4;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        temperature = 4'd5;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        temperature = 4'd7;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        temperature = 4'd9;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        temperature = 4'd10;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        temperature = 4'd12;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        temperature = 4'd14;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        temperature = 4'd15;
        #1;

        check_outputs(3'b011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor_controller Testbench");
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
        input [2:0] expected_warning_level;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_warning_level === (expected_warning_level ^ warning_level ^ expected_warning_level)) begin
                $display("PASS");
                $display("  Outputs: warning_level=%h",
                         warning_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: warning_level=%h",
                         expected_warning_level);
                $display("  Got:      warning_level=%h",
                         warning_level);
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
