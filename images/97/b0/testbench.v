`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg do_wb_i;
    reg rst_i;
    reg [4:0] wb_reg_i;
    reg [31:0] wb_val_i;
    wire do_wb_o;
    wire [4:0] wb_reg_o;
    wire [31:0] wb_val_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .do_wb_i(do_wb_i),
        .rst_i(rst_i),
        .wb_reg_i(wb_reg_i),
        .wb_val_i(wb_val_i),
        .do_wb_o(do_wb_o),
        .wb_reg_o(wb_reg_o),
        .wb_val_o(wb_val_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            do_wb_i = 0;
            wb_reg_i = 0;
            wb_val_i = 0;
            @(posedge clk_i);
            #1;
            rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Writeback (Reg 1)", test_num);
            reset_dut();

            do_wb_i = 1'b1;
            wb_reg_i = 5'd1;
            wb_val_i = 32'hDEADBEEF;

            @(posedge clk_i);
            #2;

            #1;


            check_outputs(1'b1, 5'd1, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Writeback to Max Register (Reg 31)", test_num);
            reset_dut();

            do_wb_i = 1'b1;
            wb_reg_i = 5'd31;
            wb_val_i = 32'hCAFEBABE;

            @(posedge clk_i);
            #2;

            #1;


            check_outputs(1'b1, 5'd31, 32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Writeback Disabled", test_num);
            reset_dut();

            do_wb_i = 1'b0;
            wb_reg_i = 5'd15;
            wb_val_i = 32'h12345678;

            @(posedge clk_i);
            #2;


            #1;



            check_outputs(1'b0, 5'd15, 32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Pattern", test_num);
            reset_dut();

            do_wb_i = 1'b1;
            wb_reg_i = 5'b11111;
            wb_val_i = 32'hFFFFFFFF;

            @(posedge clk_i);
            #2;

            #1;


            check_outputs(1'b1, 5'b11111, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Pattern", test_num);
            reset_dut();

            do_wb_i = 1'b0;
            wb_reg_i = 5'b00000;
            wb_val_i = 32'h00000000;

            @(posedge clk_i);
            #2;

            #1;


            check_outputs(1'b0, 5'b00000, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();


            do_wb_i = 1'b1;
            wb_reg_i = 5'd10;
            wb_val_i = 32'h5555AAAA;


            rst_i = 1'b1;
            @(posedge clk_i);
            #2;




            #1;





            check_outputs(1'b0, 5'd0, 32'h0);
            rst_i = 1'b0;
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
        input expected_do_wb_o;
        input [4:0] expected_wb_reg_o;
        input [31:0] expected_wb_val_o;
        begin
            if (expected_do_wb_o === (expected_do_wb_o ^ do_wb_o ^ expected_do_wb_o) &&
                expected_wb_reg_o === (expected_wb_reg_o ^ wb_reg_o ^ expected_wb_reg_o) &&
                expected_wb_val_o === (expected_wb_val_o ^ wb_val_o ^ expected_wb_val_o)) begin
                $display("PASS");
                $display("  Outputs: do_wb_o=%b, wb_reg_o=%h, wb_val_o=%h",
                         do_wb_o, wb_reg_o, wb_val_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: do_wb_o=%b, wb_reg_o=%h, wb_val_o=%h",
                         expected_do_wb_o, expected_wb_reg_o, expected_wb_val_o);
                $display("  Got:      do_wb_o=%b, wb_reg_o=%h, wb_val_o=%h",
                         do_wb_o, wb_reg_o, wb_val_o);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk_i, do_wb_i, rst_i, wb_reg_i, wb_val_i, do_wb_o, wb_reg_o, wb_val_o);
    end

endmodule
