`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] adr_i;
    reg clk_i;
    reg [31:0] dat_i;
    reg rst_i;
    reg stb_i;
    reg wre_i;
    reg [7:0] xadr_i;
    reg xclk_i;
    reg [31:0] xdat_i;
    reg xrst_i;
    reg xstb_i;
    reg xwre_i;
    wire [31:0] dat_o;
    wire [31:0] xdat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .rst_i(rst_i),
        .stb_i(stb_i),
        .wre_i(wre_i),
        .xadr_i(xadr_i),
        .xclk_i(xclk_i),
        .xdat_i(xdat_i),
        .xrst_i(xrst_i),
        .xstb_i(xstb_i),
        .xwre_i(xwre_i),
        .dat_o(dat_o),
        .xdat_o(xdat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1; xrst_i = 1;
            stb_i = 0; xstb_i = 0;
            wre_i = 0; xwre_i = 0;
            adr_i = 0; xadr_i = 0;
            dat_i = 0; xdat_i = 0;
            #20;
            rst_i = 0; xrst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Port A Basic Write/Read");
            reset_dut();

            adr_i = 8'h10; dat_i = 32'hAAAA_BBBB; wre_i = 1; stb_i = 1;
            @(posedge clk_i); #1;
            wre_i = 0; stb_i = 0;

            adr_i = 8'h10; stb_i = 1;
            @(posedge clk_i); #2;
            #1;

            check_outputs(32'hAAAA_BBBB, xdat_o);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Port B Basic Write/Read");
            reset_dut();

            xadr_i = 8'h20; xdat_i = 32'h1234_5678; xwre_i = 1; xstb_i = 1;
            @(posedge xclk_i); #1;
            xwre_i = 0; xstb_i = 0;

            xadr_i = 8'h20; xstb_i = 1;
            @(posedge xclk_i); #2;
            #1;

            check_outputs(dat_o, 32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Simultaneous Writes");
            reset_dut();

            adr_i = 8'h01; dat_i = 32'h1111_1111; wre_i = 1; stb_i = 1;
            xadr_i = 8'h02; xdat_i = 32'h2222_2222; xwre_i = 1; xstb_i = 1;
            @(posedge clk_i); #1;
            wre_i = 0; stb_i = 0; xwre_i = 0; xstb_i = 0;

            adr_i = 8'h01; stb_i = 1;
            xadr_i = 8'h02; xstb_i = 1;
            @(posedge clk_i); #2;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Cross-port Write A Read B");
            reset_dut();

            adr_i = 8'h55; dat_i = 32'h55AA_55AA; wre_i = 1; stb_i = 1;
            @(posedge clk_i); #1;
            wre_i = 0; stb_i = 0;

            xadr_i = 8'h55; xstb_i = 1;
            @(posedge xclk_i); #2;
            #1;

            check_outputs(dat_o, 32'h55AA_55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Strobe signal validation");
            reset_dut();

            adr_i = 8'hA0; dat_i = 32'h9999_9999; wre_i = 1; stb_i = 1;
            @(posedge clk_i); #1;

            adr_i = 8'hA0; dat_i = 32'hEEEE_EEEE; wre_i = 1; stb_i = 0;
            @(posedge clk_i); #1;
            wre_i = 0;

            adr_i = 8'hA0; stb_i = 1;
            @(posedge clk_i); #2;

            #1;


            check_outputs(32'h9999_9999, xdat_o);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Simultaneous Read same address");
            reset_dut();

            adr_i = 8'hFF; dat_i = 32'hC0DE_C0DE; wre_i = 1; stb_i = 1;
            @(posedge clk_i); #1;
            wre_i = 0; stb_i = 0;

            adr_i = 8'hFF; stb_i = 1;
            xadr_i = 8'hFF; xstb_i = 1;
            @(posedge clk_i); #2;
            #1;

            check_outputs(32'hC0DE_C0DE, 32'hC0DE_C0DE);
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
        input [31:0] expected_dat_o;
        input [31:0] expected_xdat_o;
        begin
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o) &&
                expected_xdat_o === (expected_xdat_o ^ xdat_o ^ expected_xdat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%h, xdat_o=%h",
                         dat_o, xdat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%h, xdat_o=%h",
                         expected_dat_o, expected_xdat_o);
                $display("  Got:      dat_o=%h, xdat_o=%h",
                         dat_o, xdat_o);
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
        $dumpvars(0,adr_i, clk_i, dat_i, rst_i, stb_i, wre_i, xadr_i, xclk_i, xdat_i, xrst_i, xstb_i, xwre_i, dat_o, xdat_o);
    end

endmodule
