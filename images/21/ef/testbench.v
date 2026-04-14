`timescale 1ns/1ps

module DAC_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bin_input;
    wire [9:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC dut (
        .bin_input(bin_input),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum Input (0)", test_num);
        bin_input = 8'd0;
        #1;

        check_outputs(10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Input (255)", test_num);
        bin_input = 8'd255;
        #1;

        check_outputs(10'd1023);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Midpoint Input (128)", test_num);
        bin_input = 8'd128;
        #1;

        check_outputs(10'd513);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lower Quarter Input (64)", test_num);
        bin_input = 8'd64;
        #1;

        check_outputs(10'd256);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Upper Quarter Input (192)", test_num);
        bin_input = 8'd192;
        #1;

        check_outputs(10'd770);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small Step Input (1)", test_num);
        bin_input = 8'd1;
        #1;

        check_outputs(10'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Near Max Input (254)", test_num);
        bin_input = 8'd254;
        #1;

        check_outputs(10'd1018);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arbitrary Input (100)", test_num);
        bin_input = 8'd100;
        #1;

        check_outputs(10'd401);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC Testbench");
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
        input [9:0] expected_analog_output;
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
