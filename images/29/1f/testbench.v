`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] load_condition;
    reg [2:0] voltage_level;
    wire [1:0] frequency_setting;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .load_condition(load_condition),
        .voltage_level(voltage_level),
        .frequency_setting(frequency_setting)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage Low, Load Low", test_num);
        voltage_level = 3'b000;
        load_condition = 2'b00;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage Low, Load Medium", test_num);
        voltage_level = 3'b000;
        load_condition = 2'b01;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage Low, Load High", test_num);
        voltage_level = 3'b000;
        load_condition = 2'b10;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage Medium, Load Low", test_num);
        voltage_level = 3'b001;
        load_condition = 2'b00;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage Medium, Load Medium", test_num);
        voltage_level = 3'b001;
        load_condition = 2'b01;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage Medium, Load High", test_num);
        voltage_level = 3'b001;
        load_condition = 2'b10;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage High, Load Low", test_num);
        voltage_level = 3'b010;
        load_condition = 2'b00;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage High, Load Medium", test_num);
        voltage_level = 3'b010;
        load_condition = 2'b01;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Voltage High, Load High", test_num);
        voltage_level = 3'b010;
        load_condition = 2'b10;
        #1;

        check_outputs(2'b10);
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
        input [1:0] expected_frequency_setting;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frequency_setting === (expected_frequency_setting ^ frequency_setting ^ expected_frequency_setting)) begin
                $display("PASS");
                $display("  Outputs: frequency_setting=%h",
                         frequency_setting);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency_setting=%h",
                         expected_frequency_setting);
                $display("  Got:      frequency_setting=%h",
                         frequency_setting);
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
