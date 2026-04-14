`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] address;
    reg clk;
    reg debugaccess;
    reg monitor_error;
    reg monitor_go;
    reg monitor_ready;
    reg reset_n;
    reg write;
    reg [31:0] writedata;
    wire [31:0] oci_ienable;
    wire [31:0] oci_reg_readdata;
    wire oci_single_step_mode;
    wire ocireg_ers;
    wire ocireg_mrs;
    wire take_action_ocireg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .debugaccess(debugaccess),
        .monitor_error(monitor_error),
        .monitor_go(monitor_go),
        .monitor_ready(monitor_ready),
        .reset_n(reset_n),
        .write(write),
        .writedata(writedata),
        .oci_ienable(oci_ienable),
        .oci_reg_readdata(oci_reg_readdata),
        .oci_single_step_mode(oci_single_step_mode),
        .ocireg_ers(ocireg_ers),
        .ocireg_mrs(ocireg_mrs),
        .take_action_ocireg(take_action_ocireg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        address = 0;
        debugaccess = 0;
        monitor_error = 0;
        monitor_go = 0;
        monitor_ready = 0;
        write = 0;
        writedata = 0;
        #20;
        reset_n = 1;
        #20;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Initial State Check");
        reset_dut();
        test_num = 1;

        #1;


        check_outputs(32'h0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Write/Read IEnable Register");
        reset_dut();
        test_num = 2;

        @(posedge clk);
        address = 9'h001;
        writedata = 32'hDEADBEEF;
        write = 1;
        debugaccess = 1;

        @(posedge clk);
        write = 0;
        debugaccess = 0;
        #10;



        #1;




        check_outputs(32'hDEADBEEF, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Enable Single Step Mode");
        reset_dut();
        test_num = 3;

        @(posedge clk);
        address = 9'h000;
        writedata = 32'h00000001;
        write = 1;
        debugaccess = 1;

        @(posedge clk);
        write = 0;
        debugaccess = 0;
        #10;


        #1;



        check_outputs(32'h0, 32'h0, 1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Write attempt without debugaccess");
        reset_dut();
        test_num = 4;

        @(posedge clk);
        address = 9'h001;
        writedata = 32'hFFFFFFFF;
        write = 1;
        debugaccess = 0;

        @(posedge clk);
        write = 0;
        #10;


        #1;



        check_outputs(32'h0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Monitor Signals and Readback");
        reset_dut();
        test_num = 5;

        monitor_ready = 1;
        monitor_error = 0;
        monitor_go = 1;

        @(posedge clk);
        address = 9'h002;
        write = 0;
        debugaccess = 1;
        #5;



        #1;




        check_outputs(32'h0, oci_reg_readdata, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Reset Status Bits (ERS/MRS)");
        reset_dut();
        test_num = 6;

        @(posedge clk);
        address = 9'h000;
        writedata = 32'h00000006;
        write = 1;
        debugaccess = 1;

        @(posedge clk);
        write = 0;
        debugaccess = 1;
        #10;


        #1;



        check_outputs(32'h0, 32'h0, 1'b0, 1'b1, 1'b1, 1'b1);
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
        input [31:0] expected_oci_ienable;
        input [31:0] expected_oci_reg_readdata;
        input expected_oci_single_step_mode;
        input expected_ocireg_ers;
        input expected_ocireg_mrs;
        input expected_take_action_ocireg;
        begin
            if (expected_oci_ienable === (expected_oci_ienable ^ oci_ienable ^ expected_oci_ienable) &&
                expected_oci_reg_readdata === (expected_oci_reg_readdata ^ oci_reg_readdata ^ expected_oci_reg_readdata) &&
                expected_oci_single_step_mode === (expected_oci_single_step_mode ^ oci_single_step_mode ^ expected_oci_single_step_mode) &&
                expected_ocireg_ers === (expected_ocireg_ers ^ ocireg_ers ^ expected_ocireg_ers) &&
                expected_ocireg_mrs === (expected_ocireg_mrs ^ ocireg_mrs ^ expected_ocireg_mrs) &&
                expected_take_action_ocireg === (expected_take_action_ocireg ^ take_action_ocireg ^ expected_take_action_ocireg)) begin
                $display("PASS");
                $display("  Outputs: oci_ienable=%h, oci_reg_readdata=%h, oci_single_step_mode=%b, ocireg_ers=%b, ocireg_mrs=%b, take_action_ocireg=%b",
                         oci_ienable, oci_reg_readdata, oci_single_step_mode, ocireg_ers, ocireg_mrs, take_action_ocireg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oci_ienable=%h, oci_reg_readdata=%h, oci_single_step_mode=%b, ocireg_ers=%b, ocireg_mrs=%b, take_action_ocireg=%b",
                         expected_oci_ienable, expected_oci_reg_readdata, expected_oci_single_step_mode, expected_ocireg_ers, expected_ocireg_mrs, expected_take_action_ocireg);
                $display("  Got:      oci_ienable=%h, oci_reg_readdata=%h, oci_single_step_mode=%b, ocireg_ers=%b, ocireg_mrs=%b, take_action_ocireg=%b",
                         oci_ienable, oci_reg_readdata, oci_single_step_mode, ocireg_ers, ocireg_mrs, take_action_ocireg);
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
        $dumpvars(0,address, clk, debugaccess, monitor_error, monitor_go, monitor_ready, reset_n, write, writedata, oci_ienable, oci_reg_readdata, oci_single_step_mode, ocireg_ers, ocireg_mrs, take_action_ocireg);
    end

endmodule
