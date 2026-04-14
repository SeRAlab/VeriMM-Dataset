`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] i_ctrl;
    reg [31:0] i_data0;
    reg [31:0] i_data1;
    reg [31:0] i_data2;
    reg [31:0] i_data3;
    reg [31:0] i_data4;
    reg [31:0] i_data5;
    reg [31:0] i_data6;
    reg [31:0] i_data7;
    wire [31:0] o_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_ctrl(i_ctrl),
        .i_data0(i_data0),
        .i_data1(i_data1),
        .i_data2(i_data2),
        .i_data3(i_data3),
        .i_data4(i_data4),
        .i_data5(i_data5),
        .i_data6(i_data6),
        .i_data7(i_data7),
        .o_data(o_data)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select i_data0");
            test_num = 1;
            i_data0 = 32'h1111_1111; i_data1 = 32'h2222_2222; i_data2 = 32'h3333_3333; i_data3 = 32'h4444_4444;
            i_data4 = 32'h5555_5555; i_data5 = 32'h6666_6666; i_data6 = 32'h7777_7777; i_data7 = 32'h8888_8888;
            i_ctrl = 3'b000;
            #1;

            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select i_data1");
            test_num = 2;
            i_ctrl = 3'b001;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select i_data2");
            test_num = 3;
            i_ctrl = 3'b010;
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select i_data3");
            test_num = 4;
            i_ctrl = 3'b011;
            #1;

            check_outputs(32'h4444_4444);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select i_data4");
            test_num = 5;
            i_ctrl = 3'b100;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select i_data5");
            test_num = 6;
            i_ctrl = 3'b101;
            #1;

            check_outputs(32'h6666_6666);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Select i_data6");
            test_num = 7;
            i_ctrl = 3'b110;
            #1;

            check_outputs(32'h7777_7777);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Select i_data7");
            test_num = 8;
            i_ctrl = 3'b111;
            #1;

            check_outputs(32'h8888_8888);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Change input data on selected channel (channel 4)");
            test_num = 9;
            i_ctrl = 3'b100;
            i_data4 = 32'hABCD_EF01;
            #1;

            check_outputs(32'hABCD_EF01);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Boundary values (All Fs and All 0s)");
            test_num = 10;
            i_ctrl = 3'b011;
            i_data3 = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);

            #10;
            i_data3 = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_o_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data === (expected_o_data ^ o_data ^ expected_o_data)) begin
                $display("PASS");
                $display("  Outputs: o_data=%h",
                         o_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data=%h",
                         expected_o_data);
                $display("  Got:      o_data=%h",
                         o_data);
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
