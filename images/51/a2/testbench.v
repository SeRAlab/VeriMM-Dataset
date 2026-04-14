`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] gpr_ra_a;
    reg [4:0] gpr_ra_b;
    reg [4:0] gpr_wa;
    reg [31:0] gpr_wd;
    reg gpr_we;
    wire [31:0] gpr_rd_a;
    wire [31:0] gpr_rd_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .gpr_ra_a(gpr_ra_a),
        .gpr_ra_b(gpr_ra_b),
        .gpr_wa(gpr_wa),
        .gpr_wd(gpr_wd),
        .gpr_we(gpr_we),
        .gpr_rd_a(gpr_rd_a),
        .gpr_rd_b(gpr_rd_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            gpr_ra_a = 0;
            gpr_ra_b = 0;
            gpr_wa = 0;
            gpr_wd = 0;
            gpr_we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Register 0 Hardwired Check");
            reset_dut();

            @(posedge clk);
            gpr_wa = 5'd0;
            gpr_wd = 32'hFFFFFFFF;
            gpr_we = 1'b1;
            @(posedge clk);
            gpr_we = 1'b0;

            gpr_ra_a = 5'd0;
            gpr_ra_b = 5'd0;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Write/Read (Reg 1)");
            reset_dut();
            @(posedge clk);
            gpr_wa = 5'd1;
            gpr_wd = 32'h12345678;
            gpr_we = 1'b1;
            @(posedge clk);
            gpr_we = 1'b0;

            gpr_ra_a = 5'd1;
            gpr_ra_b = 5'd0;
            #1;
            #1;

            check_outputs(32'h12345678, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Dual Port Read (Reg 2 and Reg 3)");
            reset_dut();

            @(posedge clk);
            gpr_wa = 5'd2;
            gpr_wd = 32'hAAAA_BBBB;
            gpr_we = 1'b1;
            @(posedge clk);

            gpr_wa = 5'd3;
            gpr_wd = 32'hCCCC_DDDD;
            gpr_we = 1'b1;
            @(posedge clk);
            gpr_we = 1'b0;

            gpr_ra_a = 5'd2;
            gpr_ra_b = 5'd3;
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable (WE) Validation");
            reset_dut();

            @(posedge clk);
            gpr_wa = 5'd5;
            gpr_wd = 32'h5555_5555;
            gpr_we = 1'b1;
            @(posedge clk);

            gpr_wa = 5'd5;
            gpr_wd = 32'hDEAD_BEEF;
            gpr_we = 1'b0;
            @(posedge clk);

            gpr_ra_a = 5'd5;
            gpr_ra_b = 5'd5;
            #1;
            #1;

            check_outputs(32'h5555_5555, 32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Upper Boundary (Reg 31)");
            reset_dut();
            @(posedge clk);
            gpr_wa = 5'd31;
            gpr_wd = 32'h87654321;
            gpr_we = 1'b1;
            @(posedge clk);
            gpr_we = 1'b0;
            gpr_ra_a = 5'd31;
            gpr_ra_b = 5'd0;
            #1;
            #1;

            check_outputs(32'h87654321, 32'h0);
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
        input [31:0] expected_gpr_rd_a;
        input [31:0] expected_gpr_rd_b;
        begin
            if (expected_gpr_rd_a === (expected_gpr_rd_a ^ gpr_rd_a ^ expected_gpr_rd_a) &&
                expected_gpr_rd_b === (expected_gpr_rd_b ^ gpr_rd_b ^ expected_gpr_rd_b)) begin
                $display("PASS");
                $display("  Outputs: gpr_rd_a=%h, gpr_rd_b=%h",
                         gpr_rd_a, gpr_rd_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpr_rd_a=%h, gpr_rd_b=%h",
                         expected_gpr_rd_a, expected_gpr_rd_b);
                $display("  Got:      gpr_rd_a=%h, gpr_rd_b=%h",
                         gpr_rd_a, gpr_rd_b);
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
        $dumpvars(0,clk, gpr_ra_a, gpr_ra_b, gpr_wa, gpr_wd, gpr_we, gpr_rd_a, gpr_rd_b);
    end

endmodule
