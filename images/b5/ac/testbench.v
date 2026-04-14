`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] x_imag;
    reg [1:0] x_real;
    reg [1:0] y_imag;
    reg [1:0] y_real;
    wire [1:0] z_imag;
    wire [1:0] z_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x_imag(x_imag),
        .x_real(x_real),
        .y_imag(y_imag),
        .y_real(y_real),
        .z_imag(z_imag),
        .z_real(z_real)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero addition", test_num);
            x_real = 2'd0; x_imag = 2'd0;
            y_real = 2'd0; y_imag = 2'd0;
            #1;

            check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple addition no overflow", test_num);
            x_real = 2'd1; x_imag = 2'd1;
            y_real = 2'd1; y_imag = 2'd1;
            #1;

            check_outputs(2'd2, 2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Real part overflow, Imag no overflow", test_num);
            x_real = 2'd3; x_imag = 2'd1;
            y_real = 2'd1; y_imag = 2'd1;
            #1;

            check_outputs(2'd2, 2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Real no overflow, Imag part overflow", test_num);
            x_real = 2'd1; x_imag = 2'd2;
            y_real = 2'd1; y_imag = 2'd2;
            #1;

            check_outputs(2'd0, 2'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Both parts overflow (Maximum values)", test_num);
            x_real = 2'd3; x_imag = 2'd3;
            y_real = 2'd3; y_imag = 2'd3;
            #1;

            check_outputs(2'd2, 2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mixed values", test_num);
            x_real = 2'd2; x_imag = 2'd1;
            y_real = 2'd1; y_imag = 2'd2;
            #1;

            check_outputs(2'd3, 2'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Adding zero to max values", test_num);
            x_real = 2'd3; x_imag = 2'd3;
            y_real = 2'd0; y_imag = 2'd0;
            #1;

            check_outputs(2'd3, 2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_z_imag;
        input [1:0] expected_z_real;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z_imag === (expected_z_imag ^ z_imag ^ expected_z_imag) &&
                expected_z_real === (expected_z_real ^ z_real ^ expected_z_real)) begin
                $display("PASS");
                $display("  Outputs: z_imag=%h, z_real=%h",
                         z_imag, z_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z_imag=%h, z_real=%h",
                         expected_z_imag, expected_z_real);
                $display("  Got:      z_imag=%h, z_real=%h",
                         z_imag, z_real);
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
