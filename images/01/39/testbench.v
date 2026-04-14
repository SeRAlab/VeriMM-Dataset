`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] frequency;
    reg [1:0] voltage;
    wire enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .frequency(frequency),
        .voltage(voltage),
        .enable(enable)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Voltage=11 (3V), Frequency=100 (4GHz)", test_num);
        voltage = 2'b11;
        frequency = 3'b100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Voltage=11 (3V), Frequency=011 (3GHz)", test_num);
        voltage = 2'b11;
        frequency = 3'b011;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Voltage=10 (2V), Frequency=100 (4GHz)", test_num);
        voltage = 2'b10;
        frequency = 3'b100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Voltage=11 (3V), Frequency=111 (7GHz)", test_num);
        voltage = 2'b11;
        frequency = 3'b111;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Voltage=00, Frequency=000", test_num);
        voltage = 2'b00;
        frequency = 3'b000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Voltage=11 (3V), Frequency=101 (5GHz)", test_num);
        voltage = 2'b11;
        frequency = 3'b101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Voltage=01 (1V), Frequency=110 (6GHz)", test_num);
        voltage = 2'b01;
        frequency = 3'b110;
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
        $display("dvfs_controller Testbench");
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
        input expected_enable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enable === (expected_enable ^ enable ^ expected_enable)) begin
                $display("PASS");
                $display("  Outputs: enable=%b",
                         enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable=%b",
                         expected_enable);
                $display("  Got:      enable=%b",
                         enable);
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
