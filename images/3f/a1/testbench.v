`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    reg reset;
    wire [23:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .digital_input(digital_input),
        .reset(reset),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Assertion - Output should be 0 regardless of input", test_num);
            reset = 1;
            digital_input = 24'hFFFFFF;
            #10;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Scale - Reset then input 0", test_num);
            reset = 1; #5;
            reset = 0;
            digital_input = 24'h000000;
            #10;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Scale - Reset then input 0xFFFFFF", test_num);
            reset = 1; #5;
            reset = 0;
            digital_input = 24'hFFFFFF;
            #10;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-Scale - Reset then input 0x800000", test_num);
            reset = 1; #5;
            reset = 0;
            digital_input = 24'h800000;
            #10;
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Pattern A - Reset then input 0xAAAAAA", test_num);
            reset = 1; #5;
            reset = 0;
            digital_input = 24'hAAAAAA;
            #10;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Pattern B - Reset then input 0x555555", test_num);
            reset = 1; #5;
            reset = 0;
            digital_input = 24'h555555;
            #10;
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern - Reset then input 0x123456", test_num);
            reset = 1; #5;
            reset = 0;
            digital_input = 24'h123456;
            #10;
            #1;

            check_outputs(24'h123456);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Override - Input active then Reset applied", test_num);
            reset = 1; #5;
            reset = 0;
            digital_input = 24'hDECAFB;
            #5;
            reset = 1;
            #10;
            #1;

            check_outputs(24'h000000);
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
