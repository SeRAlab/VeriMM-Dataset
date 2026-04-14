`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] wb_adr_i;
    reg wb_cyc_i;
    reg [31:0] wb_dat_i;
    reg [1:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_tga_i;
    reg wb_we_i;
    wire wb_ack_o;
    wire [31:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wb_adr_i(wb_adr_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_tga_i(wb_tga_i),
        .wb_we_i(wb_we_i),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );
    task testcase001;

        begin
            $display("Testcase 001: Write 0x12345678 to address 0x00000000");
            test_num = 1;
            wb_adr_i = 32'h0;
            wb_dat_i = 32'h12345678;
            wb_we_i  = 1'b1;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            wb_sel_i = 2'b11;
            wb_tga_i = 1'b0;
            #10;


            #1;



            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Read back from address 0x00000000");
            test_num = 2;
            wb_adr_i = 32'h0;
            wb_we_i  = 1'b0;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write 0xABCDEF01 to address 0x00000004");
            test_num = 3;
            wb_adr_i = 32'h4;
            wb_dat_i = 32'hABCDEF01;
            wb_we_i  = 1'b1;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b1, 32'hABCDEF01);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Read back from address 0x00000004");
            test_num = 4;
            wb_adr_i = 32'h4;
            wb_we_i  = 1'b0;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b1, 32'hABCDEF01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verify persistence of address 0x00000000");
            test_num = 5;
            wb_adr_i = 32'h0;
            wb_we_i  = 1'b0;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b1, 32'h12345678);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Check wb_ack_o when wb_stb_i is low");
            test_num = 6;
            wb_adr_i = 32'h0;
            wb_stb_i = 1'b0;
            wb_cyc_i = 1'b1;
            #10;

            #1;


            check_outputs(1'b0, 32'h12345678);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Check wb_ack_o when wb_cyc_i is low");
            test_num = 7;
            wb_adr_i = 32'h0;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b0;
            #10;

            #1;


            check_outputs(1'b0, 32'h12345678);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Overlapping Write - Write to address 0x00000001");
            test_num = 8;
            wb_adr_i = 32'h1;
            wb_dat_i = 32'h99887766;
            wb_we_i  = 1'b1;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b1, 32'h99887766);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Read back address 0x00000001");
            test_num = 9;
            wb_adr_i = 32'h1;
            wb_we_i  = 1'b0;
            wb_stb_i = 1'b1;
            wb_cyc_i = 1'b1;
            #10;
            #1;

            check_outputs(1'b1, 32'h99887766);
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
        input expected_wb_ack_o;
        input [31:0] expected_wb_dat_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: wb_ack_o=%b, wb_dat_o=%h",
                         wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_ack_o=%b, wb_dat_o=%h",
                         expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      wb_ack_o=%b, wb_dat_o=%h",
                         wb_ack_o, wb_dat_o);
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
