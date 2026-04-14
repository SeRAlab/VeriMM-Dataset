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
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (10 + 20)", test_num);
            ctrl = 5'd0;
            data_in_A = 16'd10;
            data_in_B = 16'd20;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (50 - 15)", test_num);
            ctrl = 5'd1;
            data_in_A = 16'd50;
            data_in_B = 16'd15;
            #1;

            check_outputs(16'd35);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND (0xAAAA & 0xF0F0)", test_num);
            ctrl = 5'd2;
            data_in_A = 16'hAAAA;
            data_in_B = 16'hF0F0;
            #1;

            check_outputs(16'hAAAA & 16'hF0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR (0x1234 | 0x5678)", test_num);
            ctrl = 5'd3;
            data_in_A = 16'h1234;
            data_in_B = 16'h5678;
            #1;

            check_outputs(16'h1234 | 16'h5678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR (0xFFFF ^ 0x0F0F)", test_num);
            ctrl = 5'd4;
            data_in_A = 16'hFFFF;
            data_in_B = 16'h0F0F;
            #1;

            check_outputs(16'hFFFF ^ 16'h0F0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Negation A (~0x00FF)", test_num);
            ctrl = 5'd5;
            data_in_A = 16'h00FF;
            data_in_B = 16'h0000;
            #1;

            check_outputs(~16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Negation B (~0x5555)", test_num);
            ctrl = 5'd6;
            data_in_A = 16'h0000;
            data_in_B = 16'h5555;
            #1;

            check_outputs(~16'h5555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Shift Left (1 << 4)", test_num);
            ctrl = 5'd7;
            data_in_A = 16'h0001;
            data_in_B = 16'd4;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Shift Right (0x0010 >> 4)", test_num);
            ctrl = 5'd8;
            data_in_A = 16'h0010;
            data_in_B = 16'd4;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Shift Right (0x8000 >>> 1)", test_num);
            ctrl = 5'd9;
            data_in_A = 16'h8000;
            data_in_B = 16'd1;

            #1;


            check_outputs(16'hC000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Equality Comparison (5 == 5)", test_num);
            ctrl = 5'd10;
            data_in_A = 16'd5;
            data_in_B = 16'd5;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Less Than (5 < 10)", test_num);
            ctrl = 5'd11;
            data_in_A = 16'd5;
            data_in_B = 16'd10;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Greater Than (10 > 5)", test_num);
            ctrl = 5'd12;
            data_in_A = 16'd10;
            data_in_B = 16'd5;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Less Than or Equal (10 <= 10)", test_num);
            ctrl = 5'd13;
            data_in_A = 16'd10;
            data_in_B = 16'd10;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Greater Than or Equal (10 >= 11)", test_num);
            ctrl = 5'd14;
            data_in_A = 16'd10;
            data_in_B = 16'd11;
            #1;

            check_outputs(16'd0);
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
        testcase013();
        testcase014();
        testcase015();
        
        
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
