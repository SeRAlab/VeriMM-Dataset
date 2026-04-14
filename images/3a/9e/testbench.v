`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] dac_input;
    reg enable;
    wire [31:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .dac_input(dac_input),
        .enable(enable),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Enable=0, Input=24'hFFFFFF", test_num);
            enable = 1'b0;
            dac_input = 24'hFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Enable=1, Input=24'h000000", test_num);
            enable = 1'b1;
            dac_input = 24'h000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Enable=1, Input=24'hFFFFFF", test_num);
            enable = 1'b1;
            dac_input = 24'hFFFFFF;
            #1;

            check_outputs(32'hFFFFFF00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Enable=1, Input=24'h123456", test_num);
            enable = 1'b1;
            dac_input = 24'h123456;
            #1;

            check_outputs(32'h12345600);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Enable=1, Input=24'hAAAAAA", test_num);
            enable = 1'b1;
            dac_input = 24'hAAAAAA;
            #1;

            check_outputs(32'hAAAAAA00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Enable=1, Input=24'h555555", test_num);
            enable = 1'b1;
            dac_input = 24'h555555;
            #1;

            check_outputs(32'h55555500);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Transition Enable 1->0, Input=24'hABCDEF", test_num);
            enable = 1'b1;
            dac_input = 24'hABCDEF;
            #1;
            enable = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Enable=1, Input=24'h800000", test_num);
            enable = 1'b1;
            dac_input = 24'h800000;
            #1;

            check_outputs(32'h80000000);
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
