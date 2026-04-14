`timescale 1ns/1ps

module ADC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] analog_input;
    wire [7:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_8bit dut (
        .analog_input(analog_input),
        .digital_output(digital_output)
    );
    task testcase001;

        begin
            test_num = 1;
            analog_input = 3'b000;
            $display("Test Case %0d: Input 000", test_num);
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            analog_input = 3'b001;
            $display("Test Case %0d: Input 001", test_num);
            #1;

            check_outputs(8'b00111111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            analog_input = 3'b010;
            $display("Test Case %0d: Input 010", test_num);
            #1;

            check_outputs(8'b01111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            analog_input = 3'b011;
            $display("Test Case %0d: Input 011", test_num);
            #1;

            check_outputs(8'b01111111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            analog_input = 3'b100;
            $display("Test Case %0d: Input 100", test_num);
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            analog_input = 3'b101;
            $display("Test Case %0d: Input 101", test_num);
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            analog_input = 3'b110;
            $display("Test Case %0d: Input 110", test_num);
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            analog_input = 3'b111;
            $display("Test Case %0d: Input 111", test_num);
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_8bit Testbench");
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
        input [7:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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
