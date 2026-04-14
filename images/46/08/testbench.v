`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] s_x;
    reg [7:0] s_y;
    reg [15:0] x;
    reg [15:0] y;
    wire [7:0] s_z;
    wire [31:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s_x(s_x),
        .s_y(s_y),
        .x(x),
        .y(y),
        .s_z(s_z),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 16'sd100; s_x = 8'd4;
            y = 16'sd200; s_y = 8'd4;

            $display("Test %0d: Addition (Same Scale)", test_num);
            #1;

            check_outputs(8'd4, 32'sd300);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 16'sd10;  s_x = 8'd5;
            y = 16'sd1;   s_y = 8'd2;

            $display("Test %0d: Addition (s_x > s_y)", test_num);
            #1;

            check_outputs(8'd5, 32'sd18);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 16'sd5;   s_x = 8'd0;
            y = 16'sd50;  s_y = 8'd3;

            $display("Test %0d: Addition (s_y > s_x)", test_num);
            #1;

            check_outputs(8'd3, 32'sd90);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = -16'sd1000; s_x = 8'd2;
            y = -16'sd2000; s_y = 8'd2;

            $display("Test %0d: Addition (Negative Result)", test_num);
            #1;

            check_outputs(8'd2, -32'sd3000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 16'sd500; s_x = 8'd6;
            y = 16'sd100; s_y = 8'd6;

            $display("Test %0d: Subtraction (Simple)", test_num);
            #1;

            check_outputs(8'd6, 32'sd400);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 16'sd100; s_x = 8'd4;
            y = 16'sd10;  s_y = 8'd2;

            $display("Test %0d: Subtraction (Alignment)", test_num);
            #1;

            check_outputs(8'd4, 32'sd60);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 16'sd15;  s_x = 8'd2;
            y = 16'sd10;  s_y = 8'd3;

            $display("Test %0d: Multiplication", test_num);
            #1;

            check_outputs(8'd5, 32'sd150);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = -16'sd50; s_x = 8'd1;
            y = 16'sd4;   s_y = 8'd1;

            $display("Test %0d: Multiplication (Negative)", test_num);
            #1;

            check_outputs(8'd2, -32'sd200);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            x = 16'sd1000; s_x = 8'd10;
            y = 16'sd10;   s_y = 8'd2;

            $display("Test %0d: Division", test_num);
            #1;

            check_outputs(8'd8, 32'sd100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            x = 16'sd30000; s_x = 8'd0;
            y = 16'sd30000; s_y = 8'd0;

            $display("Test %0d: Large Value (32-bit check)", test_num);
            #1;

            check_outputs(8'd0, 32'sd60000);
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
        input [7:0] expected_s_z;
        input [31:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s_z === (expected_s_z ^ s_z ^ expected_s_z) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: s_z=%h, z=%h",
                         s_z, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s_z=%h, z=%h",
                         expected_s_z, expected_z);
                $display("  Got:      s_z=%h, z=%h",
                         s_z, z);
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
