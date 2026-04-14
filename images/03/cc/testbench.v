`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [7:0] ref_voltage;
    wire [7:0] out_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .enable(enable),
        .ref_voltage(ref_voltage),
        .out_voltage(out_voltage)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Regulator disabled, ref_voltage at 0", test_num);
        enable = 0;
        ref_voltage = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Regulator disabled, ref_voltage at maximum", test_num);
        enable = 0;
        ref_voltage = 8'hFF;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Regulator enabled, ref_voltage at 0", test_num);
        enable = 1;
        ref_voltage = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Regulator enabled, ref_voltage at mid-range (0x7F)", test_num);
        enable = 1;
        ref_voltage = 8'h7F;

        #1;


        check_outputs(8'h7F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Regulator enabled, ref_voltage at maximum (0xFF)", test_num);
        enable = 1;
        ref_voltage = 8'hFF;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Dynamic check - Transition from enabled to disabled", test_num);

        enable = 1;
        ref_voltage = 8'hA5;
        #5;

        enable = 0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Regulator enabled, arbitrary reference (0x33)", test_num);
        enable = 1;
        ref_voltage = 8'h33;
        #1;

        check_outputs(8'h33);
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
        input [7:0] expected_out_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_voltage === (expected_out_voltage ^ out_voltage ^ expected_out_voltage)) begin
                $display("PASS");
                $display("  Outputs: out_voltage=%h",
                         out_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_voltage=%h",
                         expected_out_voltage);
                $display("  Got:      out_voltage=%h",
                         out_voltage);
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
