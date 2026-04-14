`timescale 1ns/1ps

module voltage_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] voltage_input;
    wire [2:0] voltage_category;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_sensor dut (
        .voltage_input(voltage_input),
        .voltage_category(voltage_category)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower bound of 0-10mV category", test_num);
            voltage_input = 5'd0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle of 0-10mV category", test_num);
            voltage_input = 5'd5;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper bound of 0-10mV category", test_num);
            voltage_input = 5'd10;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower bound of 11-20mV category", test_num);
            voltage_input = 5'd11;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle of 11-20mV category", test_num);
            voltage_input = 5'd15;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper bound of 11-20mV category", test_num);
            voltage_input = 5'd20;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower bound of 21-30mV category", test_num);
            voltage_input = 5'd21;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle of 21-30mV category", test_num);
            voltage_input = 5'd25;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper bound of 21-30mV category", test_num);
            voltage_input = 5'd30;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Voltage level 31mV category", test_num);
            voltage_input = 5'd31;
            #1;

            check_outputs(3'b011);
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
        input [2:0] expected_voltage_category;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_category === (expected_voltage_category ^ voltage_category ^ expected_voltage_category)) begin
                $display("PASS");
                $display("  Outputs: voltage_category=%h",
                         voltage_category);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_category=%h",
                         expected_voltage_category);
                $display("  Got:      voltage_category=%h",
                         voltage_category);
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
