`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage;
    wire signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage(voltage),
        .signal(signal)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Minimum voltage (000)", test_num);
            voltage = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Boundary value - Low (101 / 5)", test_num);
            voltage = 3'b101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Boundary value - High (110 / 6)", test_num);
            voltage = 3'b110;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Maximum voltage (111 / 7)", test_num);
            voltage = 3'b111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Random mid-range low value (011 / 3)", test_num);
            voltage = 3'b011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_sensor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal === (expected_signal ^ signal ^ expected_signal)) begin
                $display("PASS");
                $display("  Outputs: signal=%b",
                         signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal=%b",
                         expected_signal);
                $display("  Got:      signal=%b",
                         signal);
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
