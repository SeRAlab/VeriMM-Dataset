`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [4:0] reg_addr1;
    reg [4:0] reg_addr2;
    reg regwrite;
    reg [4:0] write_addr;
    wire [31:0] reg_out1;
    wire [31:0] reg_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reg_addr1(reg_addr1),
        .reg_addr2(reg_addr2),
        .regwrite(regwrite),
        .write_addr(write_addr),
        .reg_out1(reg_out1),
        .reg_out2(reg_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            regwrite = 0;
            data_in = 32'b0;
            reg_addr1 = 5'b0;
            reg_addr2 = 5'b0;
            write_addr = 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Hardwired Zero Register...");
            reset_dut();


            regwrite = 1;
            write_addr = 5'd0;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;


            regwrite = 0;
            reg_addr1 = 5'd0;
            reg_addr2 = 5'd0;
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Simple Write and Read...");
            reset_dut();


            regwrite = 1;
            write_addr = 5'd1;
            data_in = 32'hCAFE_BABE;
            @(posedge clk);
            #1;


            regwrite = 1;
            write_addr = 5'd31;
            data_in = 32'h1234_5678;
            @(posedge clk);
            #1;


            regwrite = 0;
            reg_addr1 = 5'd1;
            reg_addr2 = 5'd31;
            #1;

            #1;


            check_outputs(32'hCAFE_BABE, 32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable Check...");
            reset_dut();


            regwrite = 1;
            write_addr = 5'd5;
            data_in = 32'hAAAA_AAAA;
            @(posedge clk);
            #1;


            regwrite = 0;
            write_addr = 5'd5;
            data_in = 32'hBBBB_BBBB;
            @(posedge clk);
            #1;


            reg_addr1 = 5'd5;
            reg_addr2 = 5'd0;
            #1;


            #1;



            check_outputs(32'hAAAA_AAAA, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Dual Port Read...");
            reset_dut();


            regwrite = 1;
            write_addr = 5'd15;
            data_in = 32'hDEAD_BEEF;
            @(posedge clk);
            #1;


            regwrite = 0;
            reg_addr1 = 5'd15;
            reg_addr2 = 5'd15;
            #1;

            #1;


            check_outputs(32'hDEAD_BEEF, 32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Synchronous Write Timing...");
            reset_dut();


            regwrite = 1;
            write_addr = 5'd2;
            data_in = 32'h55AA_55AA;
            reg_addr1 = 5'd2;


            #1;
            if (reg_out1 !== 32'h0) $display("Note: Asynchronous read detected (Normal behavior for some GPR designs)");


            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h55AA_55AA, 32'h0);
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
        input [31:0] expected_reg_out1;
        input [31:0] expected_reg_out2;
        begin
            if (expected_reg_out1 === (expected_reg_out1 ^ reg_out1 ^ expected_reg_out1) &&
                expected_reg_out2 === (expected_reg_out2 ^ reg_out2 ^ expected_reg_out2)) begin
                $display("PASS");
                $display("  Outputs: reg_out1=%h, reg_out2=%h",
                         reg_out1, reg_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out1=%h, reg_out2=%h",
                         expected_reg_out1, expected_reg_out2);
                $display("  Got:      reg_out1=%h, reg_out2=%h",
                         reg_out1, reg_out2);
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
        $dumpvars(0,clk, data_in, reg_addr1, reg_addr2, regwrite, write_addr, reg_out1, reg_out2);
    end

endmodule
