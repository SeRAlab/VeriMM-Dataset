`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] performance_level;
    wire [3:0] frequency_out;
    wire [3:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .performance_level(performance_level),
        .frequency_out(frequency_out),
        .voltage_out(voltage_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase %03d: Performance Level 0", test_num);
        performance_level = 3'b000;

        #1;


        check_outputs(4'd1, 4'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase %03d: Performance Level 1", test_num);
        performance_level = 3'b001;
        #1;

        check_outputs(4'd2, 4'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nRunning Testcase %03d: Performance Level 2", test_num);
        performance_level = 3'b010;
        #1;

        check_outputs(4'd4, 4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nRunning Testcase %03d: Performance Level 3", test_num);
        performance_level = 3'b011;
        #1;

        check_outputs(4'd6, 4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nRunning Testcase %03d: Performance Level 4", test_num);
        performance_level = 3'b100;
        #1;

        check_outputs(4'd8, 4'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nRunning Testcase %03d: Performance Level 5", test_num);
        performance_level = 3'b101;
        #1;

        check_outputs(4'd10, 4'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nRunning Testcase %03d: Performance Level 6", test_num);
        performance_level = 3'b110;
        #1;

        check_outputs(4'd12, 4'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nRunning Testcase %03d: Performance Level 7", test_num);
        performance_level = 3'b111;

        #1;


        check_outputs(4'd15, 4'd15);
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
        input [3:0] expected_frequency_out;
        input [3:0] expected_voltage_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frequency_out === (expected_frequency_out ^ frequency_out ^ expected_frequency_out) &&
                expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: frequency_out=%h, voltage_out=%h",
                         frequency_out, voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_out=%h, voltage_out=%h",
                         expected_frequency_out, expected_voltage_out);
                $display("  Got:      frequency_out=%h, voltage_out=%h",
                         frequency_out, voltage_out);
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
