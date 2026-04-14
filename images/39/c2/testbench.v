`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg [1:0] Gain;
    reg [7:0] Vin;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .EN(EN),
        .Gain(Gain),
        .Vin(Vin),
        .Vout(Vout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Regulator Disabled (EN=0)");
            EN = 0;
            Gain = 2'd1;
            Vin = 8'd50;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Regulator Enabled, Gain 1");
            EN = 1;
            Gain = 2'd1;
            Vin = 8'd45;
            #1;

            check_outputs(8'd45);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Regulator Enabled, Gain 2");
            EN = 1;
            Gain = 2'd2;
            Vin = 8'd30;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Regulator Enabled, Gain 3");
            EN = 1;
            Gain = 2'd3;
            Vin = 8'd20;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Zero Input Voltage");
            EN = 1;
            Gain = 2'd2;
            Vin = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Max Input without overflow (Gain 3)");
            EN = 1;
            Gain = 2'd3;
            Vin = 8'd85;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Disable check with high input");
            EN = 0;
            Gain = 2'd3;
            Vin = 8'd100;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Switching Gain dynamically");
            EN = 1;
            Vin = 8'd40;
            Gain = 2'd1; #5;
            Gain = 2'd2;
            #1;

            check_outputs(8'd80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_voltage_regulator Testbench");
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
        input [7:0] expected_Vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h",
                         expected_Vout);
                $display("  Got:      Vout=%h",
                         Vout);
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
