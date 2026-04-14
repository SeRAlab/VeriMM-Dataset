`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] workload;
    wire [1:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .workload(workload),
        .frequency(frequency),
        .voltage(voltage)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Workload = 0 (Expect Freq=0, Volt=0)");
        workload = 4'd0;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Workload = 3 (Expect Freq=0, Volt=0)");
        workload = 4'd3;
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Workload = 4 (Expect Freq=1, Volt=1)");
        workload = 4'd4;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Workload = 7 (Expect Freq=1, Volt=1)");
        workload = 4'd7;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Workload = 8 (Expect Freq=2, Volt=2)");
        workload = 4'd8;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Workload = 11 (Expect Freq=2, Volt=2)");
        workload = 4'd11;
        #1;

        check_outputs(2'b10, 2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Workload = 12 (Expect Freq=3, Volt=3)");
        workload = 4'd12;
        #1;

        check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Workload = 15 (Expect Freq=3, Volt=3)");
        workload = 4'd15;
        #1;

        check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase 009: Workload = 5 (Expect Freq=1, Volt=1)");
        workload = 4'd5;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase 010: Workload = 10 (Expect Freq=2, Volt=2)");
        workload = 4'd10;
        #1;

        check_outputs(2'b10, 2'b10);
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
        testcase010();
        
        
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
