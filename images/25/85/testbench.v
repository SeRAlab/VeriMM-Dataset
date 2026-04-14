`timescale 1ns/1ps

module adc_simulator_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_level;
    wire [7:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_simulator dut (
        .voltage_level(voltage_level),
        .digital_output(digital_output)
    );
    task testcase001;

    begin
        $display("\nRunning Test Case 001: voltage_level = 000");
        test_num = test_num + 1;
        voltage_level = 3'b000;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Test Case 002: voltage_level = 001");
        test_num = test_num + 1;
        voltage_level = 3'b001;
        #1;

        check_outputs(8'b00111111);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Test Case 003: voltage_level = 010");
        test_num = test_num + 1;
        voltage_level = 3'b010;
        #1;

        check_outputs(8'b01111111);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Test Case 004: voltage_level = 011");
        test_num = test_num + 1;
        voltage_level = 3'b011;
        #1;

        check_outputs(8'b01111111);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Test Case 005: voltage_level = 100");
        test_num = test_num + 1;
        voltage_level = 3'b100;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Test Case 006: voltage_level = 101");
        test_num = test_num + 1;
        voltage_level = 3'b101;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning Test Case 007: voltage_level = 110");
        test_num = test_num + 1;
        voltage_level = 3'b110;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    task testcase008;

    begin
        $display("\nRunning Test Case 008: voltage_level = 111");
        test_num = test_num + 1;
        voltage_level = 3'b111;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_simulator Testbench");
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
        input [7:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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
