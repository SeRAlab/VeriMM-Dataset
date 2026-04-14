`timescale 1ns/1ps

module linear_voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_voltage;
    reg [7:0] ref_voltage;
    wire [7:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_voltage_regulator dut (
        .input_voltage(input_voltage),
        .ref_voltage(ref_voltage),
        .output_voltage(output_voltage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input < Ref (Input=50, Ref=100)", test_num);
            input_voltage = 8'd50;
            ref_voltage = 8'd100;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input > Ref (Input=200, Ref=100)", test_num);
            input_voltage = 8'd200;
            ref_voltage = 8'd100;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input == Ref (Input=128, Ref=128)", test_num);
            input_voltage = 8'd128;
            ref_voltage = 8'd128;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input (Input=0, Ref=50)", test_num);
            input_voltage = 8'd0;
            ref_voltage = 8'd50;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Reference (Input=100, Ref=0)", test_num);
            input_voltage = 8'd100;
            ref_voltage = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Values (Input=255, Ref=255)", test_num);
            input_voltage = 8'd255;
            ref_voltage = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input slightly below Ref (Input=119, Ref=120)", test_num);
            input_voltage = 8'd119;
            ref_voltage = 8'd120;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input slightly above Ref (Input=121, Ref=120)", test_num);
            input_voltage = 8'd121;
            ref_voltage = 8'd120;
            #1;

            check_outputs(8'd120);
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
        input [7:0] expected_output_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%h",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%h",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%h",
                         output_voltage);
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
