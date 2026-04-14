`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] frequency_in;
    reg [2:0] voltage_in;
    wire [2:0] frequency_out;
    wire [2:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .frequency_in(frequency_in),
        .voltage_in(voltage_in),
        .frequency_out(frequency_out),
        .voltage_out(voltage_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimal inputs - No saturation", test_num);
        voltage_in = 3'd0;
        frequency_in = 3'd0;

        #1;


        check_outputs(3'd2, 3'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range inputs - No saturation", test_num);
        voltage_in = 3'd3;
        frequency_in = 3'd3;

        #1;


        check_outputs(3'd5, 3'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Voltage at boundary (6 to 7)", test_num);
        voltage_in = 3'd6;
        frequency_in = 3'd1;

        #1;


        check_outputs(3'd3, 3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Voltage saturation (7 to 7)", test_num);
        voltage_in = 3'd7;
        frequency_in = 3'd1;

        #1;


        check_outputs(3'd3, 3'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency at boundary (5 to 7)", test_num);
        voltage_in = 3'd2;
        frequency_in = 3'd5;

        #1;


        check_outputs(3'd7, 3'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency saturation (6 to 7)", test_num);
        voltage_in = 3'd2;
        frequency_in = 3'd6;

        #1;


        check_outputs(3'd7, 3'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Frequency saturation (7 to 7)", test_num);
        voltage_in = 3'd2;
        frequency_in = 3'd7;

        #1;


        check_outputs(3'd7, 3'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both saturation (7, 7 to 7, 7)", test_num);
        voltage_in = 3'd7;
        frequency_in = 3'd7;

        #1;


        check_outputs(3'd7, 3'd7);
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
        input [2:0] expected_frequency_out;
        input [2:0] expected_voltage_out;
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
