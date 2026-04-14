`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [16:0] csr_adr_i;
    reg csr_stb_i;
    reg [15:0] csrm_dat_i;
    reg rst_i;
    reg [16:0] wb_adr_i;
    reg [15:0] wb_dat_i;
    reg [1:0] wb_sel_i;
    reg wb_stb_i;
    reg wb_we_i;
    wire [15:0] csr_dat_o;
    wire [16:0] csrm_adr_o;
    wire [15:0] csrm_dat_o;
    wire [1:0] csrm_sel_o;
    wire csrm_we_o;
    wire wb_ack_o;
    wire [15:0] wb_dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .csr_adr_i(csr_adr_i),
        .csr_stb_i(csr_stb_i),
        .csrm_dat_i(csrm_dat_i),
        .rst_i(rst_i),
        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .csr_dat_o(csr_dat_o),
        .csrm_adr_o(csrm_adr_o),
        .csrm_dat_o(csrm_dat_o),
        .csrm_sel_o(csrm_sel_o),
        .csrm_we_o(csrm_we_o),
        .wb_ack_o(wb_ack_o),
        .wb_dat_o(wb_dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            csr_adr_i = 0;
            csr_stb_i = 0;
            csrm_dat_i = 0;
            wb_adr_i = 0;
            wb_dat_i = 0;
            wb_sel_i = 0;
            wb_stb_i = 0;
            wb_we_i = 0;
            @(posedge clk_i);
            #1;
            rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000, 17'h00000, 16'h0000, 2'b00, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wb_adr_i = 17'h0AAAA;
            wb_dat_i = 16'h5555;
            wb_sel_i = 2'b11;
            wb_we_i  = 1;
            wb_stb_i = 1;

            @(posedge clk_i);
            #1;



            #1;




            check_outputs(16'h0000, 17'h0AAAA, 16'h5555, 2'b11, 1'b1, 1'b1, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            wb_adr_i = 17'h0BBBB;
            wb_sel_i = 2'b11;
            wb_we_i  = 0;
            wb_stb_i = 1;
            csrm_dat_i = 16'h1234;

            @(posedge clk_i);
            #1;

            #1;


            check_outputs(16'h0000, 17'h0BBBB, 16'h0000, 2'b11, 1'b0, 1'b1, 16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            csr_adr_i = 17'h1CCCC;
            csr_stb_i = 1;
            csrm_dat_i = 16'hFEED;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(16'hFEED, 17'h1CCCC, 16'h0000, 2'b11, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            csr_adr_i = 17'h12345;
            csr_stb_i = 1;
            csrm_dat_i = 16'hAAAA;


            wb_adr_i = 17'h05555;
            wb_dat_i = 16'hFFFF;
            wb_stb_i = 1;
            wb_we_i  = 1;

            @(posedge clk_i);
            #1;


            #1;



            check_outputs(16'hAAAA, 17'h12345, 16'h0000, 2'b11, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            wb_adr_i = 17'h01234;
            wb_sel_i = 2'b01;
            wb_stb_i = 1;
            wb_we_i  = 0;
            csrm_dat_i = 16'hAABB;

            @(posedge clk_i);
            #1;
            #1;

            check_outputs(16'h0000, 17'h01234, 16'h0000, 2'b01, 1'b0, 1'b1, 16'hAABB);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();


            wb_adr_i = 17'h00001;
            wb_stb_i = 1;
            wb_we_i  = 1;
            wb_dat_i = 16'h1111;
            @(posedge clk_i);
            #1;


            wb_adr_i = 17'h00002;
            wb_dat_i = 16'h2222;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(16'h0000, 17'h00002, 16'h2222, 2'b00, 1'b1, 1'b1, 16'h0000);
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
        input [15:0] expected_csr_dat_o;
        input [16:0] expected_csrm_adr_o;
        input [15:0] expected_csrm_dat_o;
        input [1:0] expected_csrm_sel_o;
        input expected_csrm_we_o;
        input expected_wb_ack_o;
        input [15:0] expected_wb_dat_o;
        begin
            if (expected_csr_dat_o === (expected_csr_dat_o ^ csr_dat_o ^ expected_csr_dat_o) &&
                expected_csrm_adr_o === (expected_csrm_adr_o ^ csrm_adr_o ^ expected_csrm_adr_o) &&
                expected_csrm_dat_o === (expected_csrm_dat_o ^ csrm_dat_o ^ expected_csrm_dat_o) &&
                expected_csrm_sel_o === (expected_csrm_sel_o ^ csrm_sel_o ^ expected_csrm_sel_o) &&
                expected_csrm_we_o === (expected_csrm_we_o ^ csrm_we_o ^ expected_csrm_we_o) &&
                expected_wb_ack_o === (expected_wb_ack_o ^ wb_ack_o ^ expected_wb_ack_o) &&
                expected_wb_dat_o === (expected_wb_dat_o ^ wb_dat_o ^ expected_wb_dat_o)) begin
                $display("PASS");
                $display("  Outputs: csr_dat_o=%h, csrm_adr_o=%h, csrm_dat_o=%h, csrm_sel_o=%h, csrm_we_o=%b, wb_ack_o=%b, wb_dat_o=%h",
                         csr_dat_o, csrm_adr_o, csrm_dat_o, csrm_sel_o, csrm_we_o, wb_ack_o, wb_dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: csr_dat_o=%h, csrm_adr_o=%h, csrm_dat_o=%h, csrm_sel_o=%h, csrm_we_o=%b, wb_ack_o=%b, wb_dat_o=%h",
                         expected_csr_dat_o, expected_csrm_adr_o, expected_csrm_dat_o, expected_csrm_sel_o, expected_csrm_we_o, expected_wb_ack_o, expected_wb_dat_o);
                $display("  Got:      csr_dat_o=%h, csrm_adr_o=%h, csrm_dat_o=%h, csrm_sel_o=%h, csrm_we_o=%b, wb_ack_o=%b, wb_dat_o=%h",
                         csr_dat_o, csrm_adr_o, csrm_dat_o, csrm_sel_o, csrm_we_o, wb_ack_o, wb_dat_o);
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
        $dumpvars(0,clk_i, csr_adr_i, csr_stb_i, csrm_dat_i, rst_i, wb_adr_i, wb_dat_i, wb_sel_i, wb_stb_i, wb_we_i, csr_dat_o, csrm_adr_o, csrm_dat_o, csrm_sel_o, csrm_we_o, wb_ack_o, wb_dat_o);
    end

endmodule
