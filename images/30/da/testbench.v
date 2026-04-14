`timescale 1ns/1ps

module DAC_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] digital_input;
    wire [11:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_16bit dut (
        .digital_input(digital_input),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Minimum Value (0V)", test_num);
        digital_input = 16'h0000;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Maximum Value (5V)", test_num);
        digital_input = 16'hFFFF;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Mid-scale Value (2.5V)", test_num);
        digital_input = 16'h8000;
        #1;

        check_outputs(12'h800);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Quarter-scale Value (1.25V)", test_num);
        digital_input = 16'h4000;
        #1;

        check_outputs(12'h400);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Smallest Step (LSB of output)", test_num);
        digital_input = 16'h0010;
        #1;

        check_outputs(12'h001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Input below LSB threshold of 12-bit output", test_num);
        digital_input = 16'h000F;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Arbitrary pattern 1 (0xA5A5)", test_num);
        digital_input = 16'hA5A5;
        #1;

        check_outputs(12'hA5A);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Arbitrary pattern 2 (0x1234)", test_num);
        digital_input = 16'h1234;
        #1;

        check_outputs(12'h123);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Near Full Scale (0xFFF0)", test_num);
        digital_input = 16'hFFF0;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Three-quarter scale", test_num);
        digital_input = 16'hC000;
        #1;

        check_outputs(12'hC00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_16bit Testbench");
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
