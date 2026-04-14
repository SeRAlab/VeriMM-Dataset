`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] adr_rd_i;
    reg [10:0] adr_wr_i;
    reg clk;
    reg [31:0] dat_i;
    reg rde_i;
    reg we_i;
    wire [31:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_rd_i(adr_rd_i),
        .adr_wr_i(adr_wr_i),
        .clk(clk),
        .dat_i(dat_i),
        .rde_i(rde_i),
        .we_i(we_i),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        adr_rd_i = 0;
        adr_wr_i = 0;
        dat_i = 0;
        rde_i = 0;
        we_i = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read at address 0x05", test_num);
        reset_dut();


        @(posedge clk);
        adr_wr_i = 11'h005;
        dat_i = 32'hDEADBEEF;
        we_i = 1;
        @(posedge clk);
        we_i = 0;


        @(posedge clk);
        adr_rd_i = 11'h005;
        rde_i = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write/Read at boundary address 0x7FF", test_num);
        reset_dut();


        @(posedge clk);
        adr_wr_i = 11'h7FF;
        dat_i = 32'h12345678;
        we_i = 1;
        @(posedge clk);
        we_i = 0;


        @(posedge clk);
        adr_rd_i = 11'h7FF;
        rde_i = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite data at address 0x10", test_num);
        reset_dut();


        @(posedge clk);
        adr_wr_i = 11'h010;
        dat_i = 32'hAAAA_AAAA;
        we_i = 1;
        @(posedge clk);


        adr_wr_i = 11'h010;
        dat_i = 32'h5555_5555;
        we_i = 1;
        @(posedge clk);
        we_i = 0;


        @(posedge clk);
        adr_rd_i = 11'h010;
        rde_i = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h5555_5555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Write Enable (we_i) behavior", test_num);
        reset_dut();


        @(posedge clk);
        adr_wr_i = 11'h020;
        dat_i = 32'hFFFF_FFFF;
        we_i = 0;
        @(posedge clk);


        adr_rd_i = 11'h020;
        rde_i = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simultaneous Read and Write (Dual Port functionality)", test_num);
        reset_dut();


        @(posedge clk);
        adr_wr_i = 11'h030;
        dat_i = 32'hB0BA_CAFE;
        we_i = 1;
        @(posedge clk);
        we_i = 0;


        @(posedge clk);
        adr_rd_i = 11'h030;
        rde_i = 1;
        adr_wr_i = 11'h040;
        dat_i = 32'hCAFE_BABE;
        we_i = 1;

        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hB0BA_CAFE);
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
        input [31:0] expected_dat_o;
        begin
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%h",
                         dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%h",
                         expected_dat_o);
                $display("  Got:      dat_o=%h",
                         dat_o);
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
        $dumpvars(0,adr_rd_i, adr_wr_i, clk, dat_i, rde_i, we_i, dat_o);
    end

endmodule
