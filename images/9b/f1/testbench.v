`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] wb_32_adr_i;
    reg [31:0] wb_32_dat_i;
    reg [3:0] wb_32_sel_i;
    reg [7:0] wb_8_dat_o;
    wire [31:0] wb_32_dat_o;
    wire [31:0] wb_8_adr_i;
    wire [7:0] wb_8_dat_i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb_32_adr_i(wb_32_adr_i),
        .wb_32_dat_i(wb_32_dat_i),
        .wb_32_sel_i(wb_32_sel_i),
        .wb_8_dat_o(wb_8_dat_o),
        .wb_32_dat_o(wb_32_dat_o),
        .wb_8_adr_i(wb_8_adr_i),
        .wb_8_dat_i(wb_8_dat_i)
    );
    task testcase001;

        begin
            test_num = 1;
            wb_32_sel_i = 4'b0001;
            wb_32_adr_i = 32'h12345670;
            wb_32_dat_i = 32'hAABBCCDD;
            wb_8_dat_o  = 8'h11;
            #10;




            #1;





            check_outputs(32'h00000011, 32'h00000000, 8'hDD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            wb_32_sel_i = 4'b0010;
            wb_32_adr_i = 32'h12345671;
            wb_32_dat_i = 32'hAABBCCDD;
            wb_8_dat_o  = 8'h22;
            #10;




            #1;





            check_outputs(32'h00002200, 32'h00000001, 8'hCC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            wb_32_sel_i = 4'b0100;
            wb_32_adr_i = 32'h12345672;
            wb_32_dat_i = 32'hAABBCCDD;
            wb_8_dat_o  = 8'h33;
            #10;




            #1;





            check_outputs(32'h00330000, 32'h00000002, 8'hBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            wb_32_sel_i = 4'b1000;
            wb_32_adr_i = 32'h12345673;
            wb_32_dat_i = 32'hAABBCCDD;
            wb_8_dat_o  = 8'h44;
            #10;




            #1;





            check_outputs(32'h44000000, 32'h00000003, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            wb_32_sel_i = 4'b0001;
            wb_32_adr_i = 32'hFFFFFFF4;
            wb_32_dat_i = 32'h55667788;
            wb_8_dat_o  = 8'h99;
            #10;




            #1;





            check_outputs(32'h00000099, 32'h00000000, 8'h88);
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
        input [31:0] expected_wb_32_dat_o;
        input [31:0] expected_wb_8_adr_i;
        input [7:0] expected_wb_8_dat_i;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wb_32_dat_o === (expected_wb_32_dat_o ^ wb_32_dat_o ^ expected_wb_32_dat_o) &&
                expected_wb_8_adr_i === (expected_wb_8_adr_i ^ wb_8_adr_i ^ expected_wb_8_adr_i) &&
                expected_wb_8_dat_i === (expected_wb_8_dat_i ^ wb_8_dat_i ^ expected_wb_8_dat_i)) begin
                $display("PASS");
                $display("  Outputs: wb_32_dat_o=%h, wb_8_adr_i=%h, wb_8_dat_i=%h",
                         wb_32_dat_o, wb_8_adr_i, wb_8_dat_i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_32_dat_o=%h, wb_8_adr_i=%h, wb_8_dat_i=%h",
                         expected_wb_32_dat_o, expected_wb_8_adr_i, expected_wb_8_dat_i);
                $display("  Got:      wb_32_dat_o=%h, wb_8_adr_i=%h, wb_8_dat_i=%h",
                         wb_32_dat_o, wb_8_adr_i, wb_8_dat_i);
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
