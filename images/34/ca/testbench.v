`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_in;
    wire [2:0] level_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage_in(voltage_in),
        .level_out(level_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum value (Low range)", test_num);
            voltage_in = 5'd0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle of Low range", test_num);
            voltage_in = 5'd8;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Low range boundary", test_num);
            voltage_in = 5'd15;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Medium range boundary", test_num);
            voltage_in = 5'd16;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle of Medium range", test_num);
            voltage_in = 5'd24;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value for 5-bit input (Medium range)", test_num);
            voltage_in = 5'd31;
            #1;

            check_outputs(3'd1);
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
        testcase006();
        
        
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
        input [2:0] expected_level_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_level_out === (expected_level_out ^ level_out ^ expected_level_out)) begin
                $display("PASS");
                $display("  Outputs: level_out=%h",
                         level_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: level_out=%h",
                         expected_level_out);
                $display("  Got:      level_out=%h",
                         level_out);
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
