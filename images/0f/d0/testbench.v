`timescale 1ns/1ps

module DVFS_Controller_tb;

    // Testbench signals (combinational circuit)
    reg mode;
    reg [3:0] workload;
    wire [2:0] frequency;
    wire [1:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DVFS_Controller dut (
        .mode(mode),
        .workload(workload),
        .frequency(frequency),
        .voltage(voltage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Low Power Mode, Minimum Workload", test_num);
            mode = 0;
            workload = 4'b0000;

            #1;


            check_outputs(3'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Low Power Mode, Mid Workload", test_num);
            mode = 0;
            workload = 4'b0101;

            #1;


            check_outputs(3'd5, 2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Low Power Mode, Max Workload (Truncation Check)", test_num);
            mode = 0;
            workload = 4'b1111;

            #1;


            check_outputs(3'd7, 2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Performance Mode, Minimum Workload", test_num);
            mode = 1;
            workload = 4'b0000;

            #1;


            check_outputs(3'd2, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Performance Mode, Mid Workload", test_num);
            mode = 1;
            workload = 4'b0101;

            #1;


            check_outputs(3'd7, 2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Performance Mode, Overflow Check (W=6)", test_num);
            mode = 1;
            workload = 4'b0110;

            #1;


            check_outputs(3'd0, 2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Performance Mode, Max Workload", test_num);
            mode = 1;
            workload = 4'b1111;

            #1;


            check_outputs(3'd1, 2'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Voltage Boundary Check (W=8)", test_num);
            mode = 0;
            workload = 4'b1000;

            #1;


            check_outputs(3'd0, 2'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mode Toggle Sensitivity", test_num);
            workload = 4'b0011;
            mode = 0;
            #1;
            mode = 1;

            #1;


            check_outputs(3'd5, 2'd0);
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
        input [2:0] expected_frequency;
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
