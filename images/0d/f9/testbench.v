`timescale 1ns/1ps

module DVFS_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] frequency;
    wire [1:0] voltage_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS dut (
        .frequency(frequency),
        .voltage_level(voltage_level)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 0000 (Expected Voltage 00)", test_num);
        frequency = 4'b0000;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 0001 (Expected Voltage 01)", test_num);
        frequency = 4'b0001;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 0010 (Expected Voltage 01)", test_num);
        frequency = 4'b0010;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 0011 (Expected Voltage 10)", test_num);
        frequency = 4'b0011;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 0100 (Expected Voltage 10)", test_num);
        frequency = 4'b0100;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 0101 (Expected Voltage 11)", test_num);
        frequency = 4'b0101;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 0110 (Expected Voltage 11)", test_num);
        frequency = 4'b0110;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 0111 (Expected Voltage 00)", test_num);
        frequency = 4'b0111;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 1000 (Expected Voltage 00)", test_num);
        frequency = 4'b1000;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 1001 (Expected Voltage 01)", test_num);
        frequency = 4'b1001;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 1010 (Expected Voltage 01)", test_num);
        frequency = 4'b1010;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 1011 (Expected Voltage 10)", test_num);
        frequency = 4'b1011;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 1100 (Expected Voltage 10)", test_num);
        frequency = 4'b1100;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 1101 (Expected Voltage 11)", test_num);
        frequency = 4'b1101;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 1110 (Expected Voltage 11)", test_num);
        frequency = 4'b1110;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency 1111 (Expected Voltage 00)", test_num);
        frequency = 4'b1111;
        #1;

        check_outputs(2'b00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DVFS Testbench");
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
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [1:0] expected_voltage_level;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_level === (expected_voltage_level ^ voltage_level ^ expected_voltage_level)) begin
                $display("PASS");
                $display("  Outputs: voltage_level=%h",
                         voltage_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_level=%h",
                         expected_voltage_level);
                $display("  Got:      voltage_level=%h",
                         voltage_level);
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
