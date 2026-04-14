`timescale 1ns/1ps

module DAC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control;
    wire [9:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_8bit dut (
        .control(control),
        .output_voltage(output_voltage)
    );
    task testcase001;

        begin
            test_num = 1;
            control = 3'd0;
            #10;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            control = 3'd1;
            #10;
            #1;

            check_outputs(10'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            control = 3'd2;
            #10;
            #1;

            check_outputs(10'd256);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            control = 3'd3;
            #10;
            #1;

            check_outputs(10'd385);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            control = 3'd4;
            #10;
            #1;

            check_outputs(10'd513);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            control = 3'd5;
            #10;
            #1;

            check_outputs(10'd641);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            control = 3'd6;
            #10;
            #1;

            check_outputs(10'd770);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            control = 3'd7;
            #10;
            #1;

            check_outputs(10'd898);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_8bit Testbench");
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
        input [9:0] expected_output_voltage;
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
