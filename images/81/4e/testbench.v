`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] control;
    reg dst_dac_en;
    reg [31:0] src_dac_ddata;
    reg src_dac_dunf;
    reg src_dac_dvalid;
    wire [31:0] dst_dac_ddata;
    wire dst_dac_dunf;
    wire dst_dac_dvalid;
    wire src_dac_en;
    wire [31:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .dst_dac_en(dst_dac_en),
        .src_dac_ddata(src_dac_ddata),
        .src_dac_dunf(src_dac_dunf),
        .src_dac_dvalid(src_dac_dvalid),
        .dst_dac_ddata(dst_dac_ddata),
        .dst_dac_dunf(dst_dac_dunf),
        .dst_dac_dvalid(dst_dac_dvalid),
        .src_dac_en(src_dac_en),
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
            dst_dac_en = 1'b0;
            src_dac_ddata = 32'h0;
            src_dac_dunf = 1'b0;
            src_dac_dvalid = 1'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Normal Data Transfer", test_num);
            reset_dut();

            dst_dac_en = 1'b1;
            src_dac_ddata = 32'hDEADBEEF;
            src_dac_dunf = 1'b0;
            src_dac_dvalid = 1'b1;
            control = 32'h00000001;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 1'b0, 1'b1, 1'b1, status);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Source Underflow", test_num);
            reset_dut();

            dst_dac_en = 1'b1;
            src_dac_ddata = 32'h12345678;
            src_dac_dunf = 1'b1;
            src_dac_dvalid = 1'b1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678, 1'b1, 1'b1, 1'b1, status);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Invalid Data", test_num);
            reset_dut();

            dst_dac_en = 1'b1;
            src_dac_ddata = 32'hAAAAAAAA;
            src_dac_dunf = 1'b0;
            src_dac_dvalid = 1'b0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAAAAAA, 1'b0, 1'b0, 1'b1, status);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Destination Disabled", test_num);
            reset_dut();

            dst_dac_en = 1'b0;
            src_dac_ddata = 32'h55555555;
            src_dac_dunf = 1'b0;
            src_dac_dvalid = 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h55555555, 1'b0, 1'b1, 1'b0, status);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d: Max Values", test_num);
            reset_dut();

            dst_dac_en = 1'b1;
            src_dac_ddata = 32'hFFFFFFFF;
            src_dac_dunf = 1'b1;
            src_dac_dvalid = 1'b1;
            control = 32'hFFFFFFFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1, 1'b1, 1'b1, status);
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
        input [31:0] expected_dst_dac_ddata;
        input expected_dst_dac_dunf;
        input expected_dst_dac_dvalid;
        input expected_src_dac_en;
        input [31:0] expected_status;
        begin
            if (expected_dst_dac_ddata === (expected_dst_dac_ddata ^ dst_dac_ddata ^ expected_dst_dac_ddata) &&
                expected_dst_dac_dunf === (expected_dst_dac_dunf ^ dst_dac_dunf ^ expected_dst_dac_dunf) &&
                expected_dst_dac_dvalid === (expected_dst_dac_dvalid ^ dst_dac_dvalid ^ expected_dst_dac_dvalid) &&
                expected_src_dac_en === (expected_src_dac_en ^ src_dac_en ^ expected_src_dac_en) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: dst_dac_ddata=%h, dst_dac_dunf=%b, dst_dac_dvalid=%b, src_dac_en=%b, status=%h",
                         dst_dac_ddata, dst_dac_dunf, dst_dac_dvalid, src_dac_en, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dst_dac_ddata=%h, dst_dac_dunf=%b, dst_dac_dvalid=%b, src_dac_en=%b, status=%h",
                         expected_dst_dac_ddata, expected_dst_dac_dunf, expected_dst_dac_dvalid, expected_src_dac_en, expected_status);
                $display("  Got:      dst_dac_ddata=%h, dst_dac_dunf=%b, dst_dac_dvalid=%b, src_dac_en=%b, status=%h",
                         dst_dac_ddata, dst_dac_dunf, dst_dac_dvalid, src_dac_en, status);
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
        $dumpvars(0,clk, control, dst_dac_en, src_dac_ddata, src_dac_dunf, src_dac_dvalid, dst_dac_ddata, dst_dac_dunf, dst_dac_dvalid, src_dac_en, status);
    end

endmodule
