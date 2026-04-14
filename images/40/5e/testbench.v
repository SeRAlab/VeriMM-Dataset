`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] temperature;
    wire [3:0] tens;
    wire [3:0] units;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .temperature(temperature),
        .tens(tens),
        .units(units)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 0", test_num);
        temperature = 10'd0;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 5", test_num);
        temperature = 10'd5;
        #1;

        check_outputs(4'd0, 4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 9", test_num);
        temperature = 10'd9;
        #1;

        check_outputs(4'd0, 4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 10", test_num);
        temperature = 10'd10;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 25", test_num);
        temperature = 10'd25;
        #1;

        check_outputs(4'd2, 4'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 99", test_num);
        temperature = 10'd99;
        #1;

        check_outputs(4'd9, 4'd9);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 100 (Out of Range)", test_num);
        temperature = 10'd100;
        #1;

        check_outputs(4'b1111, 4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 512 (Out of Range)", test_num);
        temperature = 10'd512;
        #1;

        check_outputs(4'b1111, 4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Temperature = 1023 (Out of Range)", test_num);
        temperature = 10'd1023;
        #1;

        check_outputs(4'b1111, 4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor Testbench");
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
        input [3:0] expected_tens;
        input [3:0] expected_units;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tens === (expected_tens ^ tens ^ expected_tens) &&
                expected_units === (expected_units ^ units ^ expected_units)) begin
                $display("PASS");
                $display("  Outputs: tens=%h, units=%h",
                         tens, units);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tens=%h, units=%h",
                         expected_tens, expected_units);
                $display("  Got:      tens=%h, units=%h",
                         tens, units);
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
