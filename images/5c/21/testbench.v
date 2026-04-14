`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] qspi_ui_dq_i;
    wire dut_io_pads_qspi_dq_0_i_ival;
    wire dut_io_pads_qspi_dq_1_i_ival;
    wire dut_io_pads_qspi_dq_2_i_ival;
    wire dut_io_pads_qspi_dq_3_i_ival;
    wire qspi_cs;
    wire qspi_sck;
    wire [3:0] qspi_ui_dq_o;
    wire [3:0] qspi_ui_dq_oe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .qspi_ui_dq_i(qspi_ui_dq_i),
        .dut_io_pads_qspi_dq_0_i_ival(dut_io_pads_qspi_dq_0_i_ival),
        .dut_io_pads_qspi_dq_1_i_ival(dut_io_pads_qspi_dq_1_i_ival),
        .dut_io_pads_qspi_dq_2_i_ival(dut_io_pads_qspi_dq_2_i_ival),
        .dut_io_pads_qspi_dq_3_i_ival(dut_io_pads_qspi_dq_3_i_ival),
        .qspi_cs(qspi_cs),
        .qspi_sck(qspi_sck),
        .qspi_ui_dq_o(qspi_ui_dq_o),
        .qspi_ui_dq_oe(qspi_ui_dq_oe)
    );
    task testcase001;

    begin
        test_num = 1;
        qspi_ui_dq_i = 4'b0000;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        qspi_ui_dq_i = 4'b1111;

        #1;


        check_outputs(1, 1, 1, 1, 0, 0, 4'h0, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        qspi_ui_dq_i = 4'b1010;

        #1;


        check_outputs(0, 1, 0, 1, 0, 0, 4'h0, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        qspi_ui_dq_i = 4'b0101;

        #1;


        check_outputs(1, 0, 1, 0, 0, 0, 4'h0, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        qspi_ui_dq_i = 4'b0001;
        #1;

        check_outputs(1, 0, 0, 0, 0, 0, 4'h0, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        qspi_ui_dq_i = 4'b0010;
        #1;

        check_outputs(0, 1, 0, 0, 0, 0, 4'h0, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        qspi_ui_dq_i = 4'b0100;
        #1;

        check_outputs(0, 0, 1, 0, 0, 0, 4'h0, 4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        qspi_ui_dq_i = 4'b1000;
        #1;

        check_outputs(0, 0, 0, 1, 0, 0, 4'h0, 4'h0);
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
        input expected_dut_io_pads_qspi_dq_0_i_ival;
        input expected_dut_io_pads_qspi_dq_1_i_ival;
        input expected_dut_io_pads_qspi_dq_2_i_ival;
        input expected_dut_io_pads_qspi_dq_3_i_ival;
        input expected_qspi_cs;
        input expected_qspi_sck;
        input [3:0] expected_qspi_ui_dq_o;
        input [3:0] expected_qspi_ui_dq_oe;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dut_io_pads_qspi_dq_0_i_ival === (expected_dut_io_pads_qspi_dq_0_i_ival ^ dut_io_pads_qspi_dq_0_i_ival ^ expected_dut_io_pads_qspi_dq_0_i_ival) &&
                expected_dut_io_pads_qspi_dq_1_i_ival === (expected_dut_io_pads_qspi_dq_1_i_ival ^ dut_io_pads_qspi_dq_1_i_ival ^ expected_dut_io_pads_qspi_dq_1_i_ival) &&
                expected_dut_io_pads_qspi_dq_2_i_ival === (expected_dut_io_pads_qspi_dq_2_i_ival ^ dut_io_pads_qspi_dq_2_i_ival ^ expected_dut_io_pads_qspi_dq_2_i_ival) &&
                expected_dut_io_pads_qspi_dq_3_i_ival === (expected_dut_io_pads_qspi_dq_3_i_ival ^ dut_io_pads_qspi_dq_3_i_ival ^ expected_dut_io_pads_qspi_dq_3_i_ival) &&
                expected_qspi_cs === (expected_qspi_cs ^ qspi_cs ^ expected_qspi_cs) &&
                expected_qspi_sck === (expected_qspi_sck ^ qspi_sck ^ expected_qspi_sck) &&
                expected_qspi_ui_dq_o === (expected_qspi_ui_dq_o ^ qspi_ui_dq_o ^ expected_qspi_ui_dq_o) &&
                expected_qspi_ui_dq_oe === (expected_qspi_ui_dq_oe ^ qspi_ui_dq_oe ^ expected_qspi_ui_dq_oe)) begin
                $display("PASS");
                $display("  Outputs: dut_io_pads_qspi_dq_0_i_ival=%b, dut_io_pads_qspi_dq_1_i_ival=%b, dut_io_pads_qspi_dq_2_i_ival=%b, dut_io_pads_qspi_dq_3_i_ival=%b, qspi_cs=%b, qspi_sck=%b, qspi_ui_dq_o=%h, qspi_ui_dq_oe=%h",
                         dut_io_pads_qspi_dq_0_i_ival, dut_io_pads_qspi_dq_1_i_ival, dut_io_pads_qspi_dq_2_i_ival, dut_io_pads_qspi_dq_3_i_ival, qspi_cs, qspi_sck, qspi_ui_dq_o, qspi_ui_dq_oe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dut_io_pads_qspi_dq_0_i_ival=%b, dut_io_pads_qspi_dq_1_i_ival=%b, dut_io_pads_qspi_dq_2_i_ival=%b, dut_io_pads_qspi_dq_3_i_ival=%b, qspi_cs=%b, qspi_sck=%b, qspi_ui_dq_o=%h, qspi_ui_dq_oe=%h",
                         expected_dut_io_pads_qspi_dq_0_i_ival, expected_dut_io_pads_qspi_dq_1_i_ival, expected_dut_io_pads_qspi_dq_2_i_ival, expected_dut_io_pads_qspi_dq_3_i_ival, expected_qspi_cs, expected_qspi_sck, expected_qspi_ui_dq_o, expected_qspi_ui_dq_oe);
                $display("  Got:      dut_io_pads_qspi_dq_0_i_ival=%b, dut_io_pads_qspi_dq_1_i_ival=%b, dut_io_pads_qspi_dq_2_i_ival=%b, dut_io_pads_qspi_dq_3_i_ival=%b, qspi_cs=%b, qspi_sck=%b, qspi_ui_dq_o=%h, qspi_ui_dq_oe=%h",
                         dut_io_pads_qspi_dq_0_i_ival, dut_io_pads_qspi_dq_1_i_ival, dut_io_pads_qspi_dq_2_i_ival, dut_io_pads_qspi_dq_3_i_ival, qspi_cs, qspi_sck, qspi_ui_dq_o, qspi_ui_dq_oe);
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
