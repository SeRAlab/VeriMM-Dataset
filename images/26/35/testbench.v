`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    wire [23:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .digital_input(digital_input),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Minimum Value (Zero)", test_num);
            digital_input = 24'h000000;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Maximum Value", test_num);
            digital_input = 24'hFFFFFF;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Most Significant Bit Only", test_num);
            digital_input = 24'h800000;
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Least Significant Bit Only", test_num);
            digital_input = 24'h000001;
            #1;

            check_outputs(24'h000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating Bits Pattern A", test_num);
            digital_input = 24'hAAAAAA;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Alternating Bits Pattern 5", test_num);
            digital_input = 24'h555555;
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Arbitrary Hex Pattern 123456", test_num);
            digital_input = 24'h123456;
            #1;

            check_outputs(24'h123456);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Arbitrary Hex Pattern CAFE88", test_num);
            digital_input = 24'hCAFE88;
            #1;

            check_outputs(24'hCAFE88);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Middle Range Value", test_num);
            digital_input = 24'h7FFFFF;
            #1;

            check_outputs(24'h7FFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Byte-wise Pattern", test_num);
            digital_input = 24'hFF00FF;
            #1;

            check_outputs(24'hFF00FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_24bit Testbench");
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
        input [23:0] expected_analog_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%h",
                         analog_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%h",
                         expected_analog_output);
                $display("  Got:      analog_output=%h",
                         analog_output);
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
