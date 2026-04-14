`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] x;
    wire [7:0] y;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 3'b000;
            #1;

            check_outputs(8'h01, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 3'b001;
            #1;

            check_outputs(8'h02, 8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 3'b010;
            #1;

            check_outputs(8'h04, 8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 3'b011;
            #1;

            check_outputs(8'h08, 8'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 3'b100;
            #1;

            check_outputs(8'h10, 8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 3'b101;
            #1;

            check_outputs(8'h20, 8'h20);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 3'b110;
            #1;

            check_outputs(8'h40, 8'h40);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 3'b111;
            #1;

            check_outputs(8'h80, 8'h80);
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
        input [7:0] expected_y;
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: y=%h, z=%h",
                         y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h, z=%h",
                         expected_y, expected_z);
                $display("  Got:      y=%h, z=%h",
                         y, z);
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
