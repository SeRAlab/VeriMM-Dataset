`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] Vref;
    reg [23:0] digital_input;
    wire [11:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .Vref(Vref),
        .digital_input(digital_input),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero digital input (Minimum)", test_num);
        Vref = 12'd4095;
        digital_input = 24'h000000;
        #1;

        check_outputs(12'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum digital input (Full Scale)", test_num);
        Vref = 12'd4095;
        digital_input = 24'hFFFFFF;

        #1;


        check_outputs(12'd4094);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-scale digital input (Vref/2)", test_num);
        Vref = 12'd4095;
        digital_input = 24'h800000;

        #1;


        check_outputs(12'd2047);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-scale with different Vref", test_num);
        Vref = 12'd2000;
        digital_input = 24'h800000;

        #1;


        check_outputs(12'd1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Quarter-scale input", test_num);
        Vref = 12'd4000;
        digital_input = 24'h400000;

        #1;


        check_outputs(12'd1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Three-quarter scale input", test_num);
        Vref = 12'd4000;
        digital_input = 24'hC00000;

        #1;


        check_outputs(12'd3000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small step scale (1/16th)", test_num);
        Vref = 12'd2048;
        digital_input = 24'h100000;

        #1;


        check_outputs(12'd128);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternative scale (1/8th)", test_num);
        Vref = 12'd4000;
        digital_input = 24'h200000;

        #1;


        check_outputs(12'd500);
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
        input [11:0] expected_analog_output;
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
