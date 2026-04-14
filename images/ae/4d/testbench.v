`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ALUCtrl_i;
    reg [31:0] data1_i;
    reg [31:0] data2_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUCtrl_i(ALUCtrl_i),
        .data1_i(data1_i),
        .data2_i(data2_i),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Addition (5 + 10)", test_num);
            data1_i = 32'd5;
            data2_i = 32'd10;
            ALUCtrl_i = 3'b000;
            #1;

            check_outputs(32'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Subtraction (100 - 40)", test_num);
            data1_i = 32'd100;
            data2_i = 32'd40;
            ALUCtrl_i = 3'b001;
            #1;

            check_outputs(32'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bitwise AND (0xAAAA_AAAA & 0x5555_FFFF)", test_num);
            data1_i = 32'hAAAA_AAAA;
            data2_i = 32'h5555_FFFF;
            ALUCtrl_i = 3'b010;
            #1;

            check_outputs(32'h0000_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bitwise OR (0x1234_0000 | 0x0000_5678)", test_num);
            data1_i = 32'h1234_0000;
            data2_i = 32'h0000_5678;
            ALUCtrl_i = 3'b011;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bitwise XOR (0xFFFF_FFFF ^ 0x1234_5678)", test_num);
            data1_i = 32'hFFFF_FFFF;
            data2_i = 32'h1234_5678;
            ALUCtrl_i = 3'b100;
            #1;

            check_outputs(32'hEDCB_A987);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiplication (12 * 12)", test_num);
            data1_i = 32'd12;
            data2_i = 32'd12;
            ALUCtrl_i = 3'b101;
            #1;

            check_outputs(32'd144);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Addition Overflow (0xFFFFFFFF + 1)", test_num);
            data1_i = 32'hFFFF_FFFF;
            data2_i = 32'h0000_0001;
            ALUCtrl_i = 3'b000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Subtraction Underflow (0 - 1)", test_num);
            data1_i = 32'h0000_0000;
            data2_i = 32'h0000_0001;
            ALUCtrl_i = 3'b001;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Large Multiplication (0x10000 * 0x10000)", test_num);
            data1_i = 32'h0001_0000;
            data2_i = 32'h0001_0000;
            ALUCtrl_i = 3'b101;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Zero Inputs Logical AND", test_num);
            data1_i = 32'h0;
            data2_i = 32'hFFFF_FFFF;
            ALUCtrl_i = 3'b010;
            #1;

            check_outputs(32'h0);
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
        input [31:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
