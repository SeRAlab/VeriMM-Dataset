`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] ctrl;
    reg [15:0] data_in_A;
    reg [15:0] data_in_B;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .data_in_A(data_in_A),
        .data_in_B(data_in_B),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (15 + 27)", test_num);
            ctrl = 5'd0;
            data_in_A = 16'd15;
            data_in_B = 16'd27;
            #1;

            check_outputs(16'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Subtraction (100 - 45)", test_num);
            ctrl = 5'd1;
            data_in_A = 16'd100;
            data_in_B = 16'd45;
            #1;

            check_outputs(16'd55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Multiplication (12 * 10)", test_num);
            ctrl = 5'd2;
            data_in_A = 16'd12;
            data_in_B = 16'd10;
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Division (144 / 12)", test_num);
            ctrl = 5'd3;
            data_in_A = 16'd144;
            data_in_B = 16'd12;
            #1;

            check_outputs(16'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Bitwise AND (0xAAAA & 0xF0F0)", test_num);
            ctrl = 5'd4;
            data_in_A = 16'hAAAA;
            data_in_B = 16'hF0F0;
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Bitwise OR (0x1234 | 0x8765)", test_num);
            ctrl = 5'd5;
            data_in_A = 16'h1234;
            data_in_B = 16'h8765;
            #1;

            check_outputs(16'h9775);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bitwise XOR (0xFFFF ^ 0x00FF)", test_num);
            ctrl = 5'd6;
            data_in_A = 16'hFFFF;
            data_in_B = 16'h00FF;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Bitwise Complement NOT (0x00FF)", test_num);
            ctrl = 5'd7;
            data_in_A = 16'h00FF;
            data_in_B = 16'h0000;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Logical Shift Left (0x0001 << 4)", test_num);
            ctrl = 5'd8;
            data_in_A = 16'h0001;
            data_in_B = 16'd4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Logical Shift Right (0x0010 >> 4)", test_num);
            ctrl = 5'd9;
            data_in_A = 16'h0010;
            data_in_B = 16'd4;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Arithmetic Shift Right (0x8000 >>> 4)", test_num);
            ctrl = 5'd10;
            data_in_A = 16'h8000;
            data_in_B = 16'd4;
            #1;

            check_outputs(16'hF800);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Subtraction Resulting in Negative (5 - 10)", test_num);
            ctrl = 5'd1;
            data_in_A = 16'd5;
            data_in_B = 16'd10;
            #1;

            check_outputs(16'hFFF6);
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
        testcase011();
        testcase012();
        
        
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
