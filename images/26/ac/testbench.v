`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    wire [31:0] analog_output;

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
            $display("Testcase %0d: Minimum value (0x000000)", test_num);
            digital_input = 24'h000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Maximum value (0xFFFFFF)", test_num);
            digital_input = 24'hFFFFFF;
            #1;

            check_outputs(32'hFFFFFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: MSB Set (0x800000)", test_num);
            digital_input = 24'h800000;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: LSB Set (0x000001)", test_num);
            digital_input = 24'h000001;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Alternating pattern A (0xAAAAAA)", test_num);
            digital_input = 24'hAAAAAA;
            #1;

            check_outputs(32'hAAAAAA00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Alternating pattern 5 (0x555555)", test_num);
            digital_input = 24'h555555;
            #1;

            check_outputs(32'h55555500);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Random hex pattern (0x123456)", test_num);
            digital_input = 24'h123456;
            #1;

            check_outputs(32'h12345600);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Mid-range value (0x7FFFFF)", test_num);
            digital_input = 24'h7FFFFF;
            #1;

            check_outputs(32'h7FFFFF00);
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
        input [31:0] expected_analog_output;
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
