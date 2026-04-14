`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_in;
    wire voltage_ok;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage_in(voltage_in),
        .voltage_ok(voltage_ok)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 0V (Below Range)", test_num);
        voltage_in = 3'b000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 1V (Below Range)", test_num);
        voltage_in = 3'b001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 2V (Below Range)", test_num);
        voltage_in = 3'b010;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 3V (Lower Bound - OK)", test_num);
        voltage_in = 3'b011;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 4V (Within Range - OK)", test_num);
        voltage_in = 3'b100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 5V (Upper Bound - OK)", test_num);
        voltage_in = 3'b101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 6V (Above Range)", test_num);
        voltage_in = 3'b110;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input = 7V (Above Range)", test_num);
        voltage_in = 3'b111;
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
        input expected_voltage_ok;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_ok === (expected_voltage_ok ^ voltage_ok ^ expected_voltage_ok)) begin
                $display("PASS");
                $display("  Outputs: voltage_ok=%b",
                         voltage_ok);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_ok=%b",
                         expected_voltage_ok);
                $display("  Got:      voltage_ok=%b",
                         voltage_ok);
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
