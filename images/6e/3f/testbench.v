`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] control;
    reg dst_adc_dovf;
    reg [31:0] src_adc_ddata;
    reg src_adc_dsync;
    reg src_adc_dwr;
    wire [31:0] dst_adc_ddata;
    wire dst_adc_dsync;
    wire dst_adc_dwr;
    wire src_adc_dovf;
    wire [31:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .dst_adc_dovf(dst_adc_dovf),
        .src_adc_ddata(src_adc_ddata),
        .src_adc_dsync(src_adc_dsync),
        .src_adc_dwr(src_adc_dwr),
        .dst_adc_ddata(dst_adc_ddata),
        .dst_adc_dsync(dst_adc_dsync),
        .dst_adc_dwr(dst_adc_dwr),
        .src_adc_dovf(src_adc_dovf),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 32'h0;
            dst_adc_dovf = 0;
            src_adc_ddata = 32'h0;
            src_adc_dsync = 0;
            src_adc_dwr = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset/Idle State Check");
            reset_dut();

            #1;


            check_outputs(32'h0, 0, 0, 0, RP_ID);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Data Transfer");
            reset_dut();
            @(negedge clk);
            src_adc_ddata = 32'hDEADBEEF;
            src_adc_dwr = 1;
            src_adc_dsync = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'hDEADBEEF, 0, 1, 0, RP_ID);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Data Transfer with Sync");
            reset_dut();
            @(negedge clk);
            src_adc_ddata = 32'h12345678;
            src_adc_dwr = 1;
            src_adc_dsync = 1;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'h12345678, 1, 1, 0, RP_ID);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overflow Handling");
            reset_dut();
            @(negedge clk);
            dst_adc_dovf = 1;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'h0, 0, 0, 1, RP_ID);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Control Signal and Status Check");
            reset_dut();
            @(negedge clk);
            control = 32'hFFFF_FFFF;
            src_adc_ddata = 32'hCAFEFACE;
            src_adc_dwr = 1;
            @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(32'hCAFEFACE, 0, 1, 0, RP_ID);
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
        input [31:0] expected_dst_adc_ddata;
        input expected_dst_adc_dsync;
        input expected_dst_adc_dwr;
        input expected_src_adc_dovf;
        input [31:0] expected_status;
        begin
            if (expected_dst_adc_ddata === (expected_dst_adc_ddata ^ dst_adc_ddata ^ expected_dst_adc_ddata) &&
                expected_dst_adc_dsync === (expected_dst_adc_dsync ^ dst_adc_dsync ^ expected_dst_adc_dsync) &&
                expected_dst_adc_dwr === (expected_dst_adc_dwr ^ dst_adc_dwr ^ expected_dst_adc_dwr) &&
                expected_src_adc_dovf === (expected_src_adc_dovf ^ src_adc_dovf ^ expected_src_adc_dovf) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: dst_adc_ddata=%h, dst_adc_dsync=%b, dst_adc_dwr=%b, src_adc_dovf=%b, status=%h",
                         dst_adc_ddata, dst_adc_dsync, dst_adc_dwr, src_adc_dovf, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dst_adc_ddata=%h, dst_adc_dsync=%b, dst_adc_dwr=%b, src_adc_dovf=%b, status=%h",
                         expected_dst_adc_ddata, expected_dst_adc_dsync, expected_dst_adc_dwr, expected_src_adc_dovf, expected_status);
                $display("  Got:      dst_adc_ddata=%h, dst_adc_dsync=%b, dst_adc_dwr=%b, src_adc_dovf=%b, status=%h",
                         dst_adc_ddata, dst_adc_dsync, dst_adc_dwr, src_adc_dovf, status);
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
        $dumpvars(0,clk, control, dst_adc_dovf, src_adc_ddata, src_adc_dsync, src_adc_dwr, dst_adc_ddata, dst_adc_dsync, dst_adc_dwr, src_adc_dovf, status);
    end

endmodule
