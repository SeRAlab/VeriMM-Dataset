`timescale 1ns/1ps

module dac_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] select;
    wire [15:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_controller dut (
        .select(select),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            $display("Testcase 001: Checking inputs 0 to 3");
            select = 4'd0;
            #1;

            check_outputs(16'h0000);

            select = 4'd1;
            #1;

            check_outputs(16'h1111);

            select = 4'd2;
            #1;

            check_outputs(16'h2222);

            select = 4'd3;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Checking inputs 4 to 7");
            select = 4'd4;
            #1;

            check_outputs(16'h4444);

            select = 4'd5;
            #1;

            check_outputs(16'h5555);

            select = 4'd6;
            #1;

            check_outputs(16'h6666);

            select = 4'd7;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Checking inputs 8 to 11");
            select = 4'd8;
            #1;

            check_outputs(16'h8888);

            select = 4'd9;
            #1;

            check_outputs(16'h9999);

            select = 4'd10;
            #1;

            check_outputs(16'hAAAA);

            select = 4'd11;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking inputs 12 to 15");
            select = 4'd12;
            #1;

            check_outputs(16'hCCCC);

            select = 4'd13;
            #1;

            check_outputs(16'hDDDD);

            select = 4'd14;
            #1;

            check_outputs(16'hEEEE);

            select = 4'd15;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_analog_output;
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
