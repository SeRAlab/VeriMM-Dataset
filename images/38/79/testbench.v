`timescale 1ns/1ps

module DAC_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_input;
    wire [9:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC dut (
        .binary_input(binary_input),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: Minimum Input (0)");
            binary_input = 8'h00;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Maximum Input (255)");
            binary_input = 8'hFF;

            #1;


            check_outputs(10'd1020);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Midpoint Input (128)");
            binary_input = 8'h80;

            #1;


            check_outputs(10'd512);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Minimum Step (1)");
            binary_input = 8'h01;

            #1;


            check_outputs(10'd4);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Quarter Scale (64)");
            binary_input = 8'h40;

            #1;


            check_outputs(10'd256);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Three-Quarter Scale (192)");
            binary_input = 8'hC0;

            #1;


            check_outputs(10'd768);
        end
        endtask

    task testcase007;

        begin
            $display("\nTest Case 007: Alternating Pattern (0xAA)");
            binary_input = 8'hAA;

            #1;


            check_outputs(10'd680);
        end
        endtask

    task testcase008;

        begin
            $display("\nTest Case 008: Alternating Pattern (0x55)");
            binary_input = 8'h55;

            #1;


            check_outputs(10'd340);
        end
        endtask

    task testcase009;

        begin
            $display("\nTest Case 009: Near Midpoint (127)");
            binary_input = 8'h7F;

            #1;


            check_outputs(10'd508);
        end
        endtask

    task testcase010;

        begin
            $display("\nTest Case 010: Near Maximum (254)");
            binary_input = 8'hFE;

            #1;


            check_outputs(10'd1016);
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
