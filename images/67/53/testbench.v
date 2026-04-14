`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg load_pending_i;
    reg mult_ex_i;
    reg [4:0] ra_i;
    reg [31:0] ra_regval_i;
    reg [4:0] rb_i;
    reg [31:0] rb_regval_i;
    reg [4:0] rd_ex_i;
    reg [4:0] rd_load_i;
    reg [4:0] rd_wb_i;
    reg [31:0] result_ex_i;
    reg [31:0] result_wb_i;
    wire resolved_o;
    wire [31:0] result_ra_o;
    wire [31:0] result_rb_o;
    wire stall_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .load_pending_i(load_pending_i),
        .mult_ex_i(mult_ex_i),
        .ra_i(ra_i),
        .ra_regval_i(ra_regval_i),
        .rb_i(rb_i),
        .rb_regval_i(rb_regval_i),
        .rd_ex_i(rd_ex_i),
        .rd_load_i(rd_load_i),
        .rd_wb_i(rd_wb_i),
        .result_ex_i(result_ex_i),
        .result_wb_i(result_wb_i),
        .resolved_o(resolved_o),
        .result_ra_o(result_ra_o),
        .result_rb_o(result_rb_o),
        .stall_o(stall_o)
    );
    task testcase001;

        begin
            test_num = 1;

            ra_i = 5'd1;
            rb_i = 5'd2;
            ra_regval_i = 32'hAAAA_AAAA;
            rb_regval_i = 32'hBBBB_BBBB;
            rd_ex_i = 5'd10;
            rd_wb_i = 5'd11;
            load_pending_i = 0;
            rd_load_i = 5'd0;
            mult_ex_i = 0;
            result_ex_i = 32'hEXEX_EXEX;
            result_wb_i = 32'hWBWB_WBWB;


            #1;



            check_outputs(1'b1, 32'hAAAA_AAAA, 32'hBBBB_BBBB, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            ra_i = 5'd5;
            rb_i = 5'd6;
            ra_regval_i = 32'h1111_1111;
            rb_regval_i = 32'h2222_2222;
            rd_ex_i = 5'd5;
            rd_wb_i = 5'd10;
            load_pending_i = 0;
            rd_load_i = 5'd0;
            mult_ex_i = 0;
            result_ex_i = 32'hCCCC_CCCC;
            result_wb_i = 32'hDDDD_DDDD;


            #1;



            check_outputs(1'b1, 32'hCCCC_CCCC, 32'h2222_2222, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            ra_i = 5'd7;
            rb_i = 5'd8;
            ra_regval_i = 32'h3333_3333;
            rb_regval_i = 32'h4444_4444;
            rd_ex_i = 5'd15;
            rd_wb_i = 5'd8;
            load_pending_i = 0;
            rd_load_i = 5'd0;
            mult_ex_i = 0;
            result_ex_i = 32'hEEEE_EEEE;
            result_wb_i = 32'hFFFF_FFFF;


            #1;



            check_outputs(1'b1, 32'h3333_3333, 32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            ra_i = 5'd3;
            rb_i = 5'd4;
            rd_ex_i = 5'd3;
            rd_wb_i = 5'd4;
            ra_regval_i = 32'h0;
            rb_regval_i = 32'h0;
            result_ex_i = 32'h1234_5678;
            result_wb_i = 32'h8765_4321;
            load_pending_i = 0;


            #1;



            check_outputs(1'b1, 32'h1234_5678, 32'h8765_4321, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            ra_i = 5'd9;
            rb_i = 5'd12;
            rd_ex_i = 5'd9;
            rd_wb_i = 5'd9;
            result_ex_i = 32'hAAAA_1111;
            result_wb_i = 32'hBBBB_2222;
            load_pending_i = 0;


            #1;



            check_outputs(1'b1, 32'hAAAA_1111, rb_regval_i, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            ra_i = 5'd14;
            rb_i = 5'd15;
            load_pending_i = 1;
            rd_load_i = 5'd14;
            rd_ex_i = 5'd0;
            rd_wb_i = 5'd0;


            #1;



            check_outputs(1'b0, ra_regval_i, rb_regval_i, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            ra_i = 5'd16;
            rb_i = 5'd17;
            load_pending_i = 1;
            rd_load_i = 5'd17;
            rd_ex_i = 5'd0;
            rd_wb_i = 5'd0;


            #1;



            check_outputs(1'b0, ra_regval_i, rb_regval_i, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;

            ra_i = 5'd0;
            rb_i = 5'd0;
            ra_regval_i = 32'h0;
            rb_regval_i = 32'h0;
            rd_ex_i = 5'd0;
            rd_wb_i = 5'd0;
            result_ex_i = 32'hFFFF_FFFF;
            result_wb_i = 32'hEEEE_EEEE;


            #1;



            check_outputs(1'b1, 32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;


            ra_i = 5'd20;
            rb_i = 5'd21;
            rd_ex_i = 5'd20;
            mult_ex_i = 1;
            load_pending_i = 0;


            #1;



            check_outputs(1'b0, ra_regval_i, rb_regval_i, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            ra_i = 5'd22;
            rb_i = 5'd23;
            load_pending_i = 1;
            rd_load_i = 5'd24;
            rd_ex_i = 5'd22;
            result_ex_i = 32'h9999_8888;


            #1;



            check_outputs(1'b1, 32'h9999_8888, rb_regval_i, 1'b0);
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
        input expected_resolved_o;
        input [31:0] expected_result_ra_o;
        input [31:0] expected_result_rb_o;
        input expected_stall_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resolved_o === (expected_resolved_o ^ resolved_o ^ expected_resolved_o) &&
                expected_result_ra_o === (expected_result_ra_o ^ result_ra_o ^ expected_result_ra_o) &&
                expected_result_rb_o === (expected_result_rb_o ^ result_rb_o ^ expected_result_rb_o) &&
                expected_stall_o === (expected_stall_o ^ stall_o ^ expected_stall_o)) begin
                $display("PASS");
                $display("  Outputs: resolved_o=%b, result_ra_o=%h, result_rb_o=%h, stall_o=%b",
                         resolved_o, result_ra_o, result_rb_o, stall_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resolved_o=%b, result_ra_o=%h, result_rb_o=%h, stall_o=%b",
                         expected_resolved_o, expected_result_ra_o, expected_result_rb_o, expected_stall_o);
                $display("  Got:      resolved_o=%b, result_ra_o=%h, result_rb_o=%h, stall_o=%b",
                         resolved_o, result_ra_o, result_rb_o, stall_o);
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
