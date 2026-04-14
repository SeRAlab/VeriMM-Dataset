`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a0;
    reg [7:0] a1;
    reg [7:0] a2;
    reg [7:0] a3;
    reg [7:0] a4;
    reg [7:0] a5;
    reg [7:0] a6;
    reg [7:0] a7;
    reg [2:0] s;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .a7(a7),
        .s(s),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a0 = 8'hA0; a1 = 8'hA1; a2 = 8'hA2; a3 = 8'hA3;
            a4 = 8'hA4; a5 = 8'hA5; a6 = 8'hA6; a7 = 8'hA7;
            s = 3'b000;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a0 = 8'hA0; a1 = 8'hA1; a2 = 8'hA2; a3 = 8'hA3;
            a4 = 8'hA4; a5 = 8'hA5; a6 = 8'hA6; a7 = 8'hA7;
            s = 3'b001;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a0 = 8'hA0; a1 = 8'hA1; a2 = 8'hA2; a3 = 8'hA3;
            a4 = 8'hA4; a5 = 8'hA5; a6 = 8'hA6; a7 = 8'hA7;
            s = 3'b010;
            #1;

            check_outputs(8'hA2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a0 = 8'hA0; a1 = 8'hA1; a2 = 8'hA2; a3 = 8'hA3;
            a4 = 8'hA4; a5 = 8'hA5; a6 = 8'hA6; a7 = 8'hA7;
            s = 3'b011;
            #1;

            check_outputs(8'hA3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a0 = 8'hA0; a1 = 8'hA1; a2 = 8'hA2; a3 = 8'hA3;
            a4 = 8'hA4; a5 = 8'hA5; a6 = 8'hA6; a7 = 8'hA7;
            s = 3'b100;
            #1;

            check_outputs(8'hA4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a0 = 8'hA0; a1 = 8'hA1; a2 = 8'hA2; a3 = 8'hA3;
            a4 = 8'hA4; a5 = 8'hA5; a6 = 8'hA6; a7 = 8'hA7;
            s = 3'b101;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a0 = 8'hA0; a1 = 8'hA1; a2 = 8'hA2; a3 = 8'hA3;
            a4 = 8'hA4; a5 = 8'hA5; a6 = 8'hA6; a7 = 8'hA7;
            s = 3'b110;
            #1;

            check_outputs(8'hA6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a0 = 8'hA0; a1 = 8'hA1; a2 = 8'hA2; a3 = 8'hA3;
            a4 = 8'hA4; a5 = 8'hA5; a6 = 8'hA6; a7 = 8'hA7;
            s = 3'b111;
            #1;

            check_outputs(8'hA7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            a0 = 8'h00; a1 = 8'hFF; a2 = 8'hFF; a3 = 8'hFF;
            a4 = 8'hFF; a5 = 8'hFF; a6 = 8'hFF; a7 = 8'hFF;
            s = 3'b000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            a0 = 8'h00; a1 = 8'h00; a2 = 8'h00; a3 = 8'h00;
            a4 = 8'h00; a5 = 8'h00; a6 = 8'h00; a7 = 8'hFF;
            s = 3'b111;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
