`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_in;
    wire [4:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .voltage_in(voltage_in),
        .voltage_out(voltage_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Minimum input voltage (0)");
        voltage_in = 5'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input voltage below limit (10)");
        voltage_in = 5'd10;
        #1;

        check_outputs(5'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input voltage at the limit (20)");
        voltage_in = 5'd20;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input voltage just above limit (21)");
        voltage_in = 5'd21;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Maximum possible input voltage (31)");
        voltage_in = 5'd31;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input voltage in upper overflow range (25)");
        voltage_in = 5'd25;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input voltage below limit (15)");
        voltage_in = 5'd15;
        #1;

        check_outputs(5'd15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [4:0] expected_voltage_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: voltage_out=%h",
                         voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_out=%h",
                         expected_voltage_out);
                $display("  Got:      voltage_out=%h",
                         voltage_out);
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
