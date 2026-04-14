`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PC_source;
    reg mem_to_reg_e;
    reg [2:0] reg_read_adr1_d;
    reg [2:0] reg_read_adr1_e;
    reg [2:0] reg_read_adr2_d;
    reg [2:0] reg_read_adr2_e;
    reg [2:0] reg_write_adr_e;
    reg [2:0] reg_write_adr_m;
    reg [2:0] reg_write_adr_w;
    reg reg_write_m;
    reg reg_write_w;
    wire flush_d;
    wire flush_e;
    wire [1:0] forward1_e;
    wire [1:0] forward2_e;
    wire stall_d;
    wire stall_f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC_source(PC_source),
        .mem_to_reg_e(mem_to_reg_e),
        .reg_read_adr1_d(reg_read_adr1_d),
        .reg_read_adr1_e(reg_read_adr1_e),
        .reg_read_adr2_d(reg_read_adr2_d),
        .reg_read_adr2_e(reg_read_adr2_e),
        .reg_write_adr_e(reg_write_adr_e),
        .reg_write_adr_m(reg_write_adr_m),
        .reg_write_adr_w(reg_write_adr_w),
        .reg_write_m(reg_write_m),
        .reg_write_w(reg_write_w),
        .flush_d(flush_d),
        .flush_e(flush_e),
        .forward1_e(forward1_e),
        .forward2_e(forward2_e),
        .stall_d(stall_d),
        .stall_f(stall_f)
    );
    task initialize_inputs;

        begin
            PC_source = 0;
            mem_to_reg_e = 0;
            reg_read_adr1_d = 0;
            reg_read_adr1_e = 0;
            reg_read_adr2_d = 0;
            reg_read_adr2_e = 0;
            reg_write_adr_e = 0;
            reg_write_adr_m = 0;
            reg_write_adr_w = 0;
            reg_write_m = 0;
            reg_write_w = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            initialize_inputs();

            #1;


            check_outputs(0, 0, 2'b00, 2'b00, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            initialize_inputs();
            reg_read_adr1_e = 3'b010;
            reg_write_adr_m = 3'b010;
            reg_write_m = 1;

            #1;


            check_outputs(0, 0, 2'b10, 2'b00, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            initialize_inputs();
            reg_read_adr2_e = 3'b101;
            reg_write_adr_m = 3'b101;
            reg_write_m = 1;

            #1;


            check_outputs(0, 0, 2'b00, 2'b10, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            initialize_inputs();
            reg_read_adr1_e = 3'b110;
            reg_write_adr_w = 3'b110;
            reg_write_w = 1;

            #1;


            check_outputs(0, 0, 2'b01, 2'b00, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            initialize_inputs();
            reg_read_adr2_e = 3'b011;
            reg_write_adr_w = 3'b011;
            reg_write_w = 1;

            #1;


            check_outputs(0, 0, 2'b00, 2'b01, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            initialize_inputs();
            reg_read_adr1_e = 3'b100;
            reg_write_adr_m = 3'b100;
            reg_write_m = 1;
            reg_write_adr_w = 3'b100;
            reg_write_w = 1;

            #1;


            check_outputs(0, 0, 2'b10, 2'b00, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            initialize_inputs();
            reg_read_adr1_e = 3'b000;
            reg_write_adr_m = 3'b000;
            reg_write_m = 1;

            #1;


            check_outputs(0, 0, 2'b00, 2'b00, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            initialize_inputs();
            mem_to_reg_e = 1;
            reg_write_adr_e = 3'b010;
            reg_read_adr1_d = 3'b010;

            #1;


            check_outputs(0, 1, 2'b00, 2'b00, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            initialize_inputs();
            PC_source = 1;

            #1;


            check_outputs(1, 1, 2'b00, 2'b00, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            initialize_inputs();
            PC_source = 1;
            mem_to_reg_e = 1;
            reg_write_adr_e = 3'b111;
            reg_read_adr2_d = 3'b111;

            #1;


            check_outputs(1, 1, 2'b00, 2'b00, 1, 1);
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
        input expected_flush_d;
        input expected_flush_e;
        input [1:0] expected_forward1_e;
        input [1:0] expected_forward2_e;
        input expected_stall_d;
        input expected_stall_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flush_d === (expected_flush_d ^ flush_d ^ expected_flush_d) &&
                expected_flush_e === (expected_flush_e ^ flush_e ^ expected_flush_e) &&
                expected_forward1_e === (expected_forward1_e ^ forward1_e ^ expected_forward1_e) &&
                expected_forward2_e === (expected_forward2_e ^ forward2_e ^ expected_forward2_e) &&
                expected_stall_d === (expected_stall_d ^ stall_d ^ expected_stall_d) &&
                expected_stall_f === (expected_stall_f ^ stall_f ^ expected_stall_f)) begin
                $display("PASS");
                $display("  Outputs: flush_d=%b, flush_e=%b, forward1_e=%h, forward2_e=%h, stall_d=%b, stall_f=%b",
                         flush_d, flush_e, forward1_e, forward2_e, stall_d, stall_f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flush_d=%b, flush_e=%b, forward1_e=%h, forward2_e=%h, stall_d=%b, stall_f=%b",
                         expected_flush_d, expected_flush_e, expected_forward1_e, expected_forward2_e, expected_stall_d, expected_stall_f);
                $display("  Got:      flush_d=%b, flush_e=%b, forward1_e=%h, forward2_e=%h, stall_d=%b, stall_f=%b",
                         flush_d, flush_e, forward1_e, forward2_e, stall_d, stall_f);
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
