`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg me_WREG;
    reg [31:0] me_memdata;
    reg [4:0] me_td;
    reg rst;
    reg stall;
    wire wb_WREG;
    wire [31:0] wb_memdata;
    wire [4:0] wb_td;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .me_WREG(me_WREG),
        .me_memdata(me_memdata),
        .me_td(me_td),
        .rst(rst),
        .stall(stall),
        .wb_WREG(wb_WREG),
        .wb_memdata(wb_memdata),
        .wb_td(wb_td)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        stall = 0;
        me_WREG = 0;
        me_memdata = 0;
        me_td = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 32'h0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Data Transfer", test_num);
        reset_dut();


        me_WREG = 1'b1;
        me_memdata = 32'hABCD1234;
        me_td = 5'd15;

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 32'hABCD1234, 5'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Stall Clears Outputs", test_num);
        reset_dut();


        me_WREG = 1'b1;
        me_memdata = 32'hFFFFFFFF;
        me_td = 5'd31;
        stall = 1'b1;

        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b0, 32'h0, 5'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Recovery After Stall", test_num);
        reset_dut();


        stall = 1'b1;
        me_WREG = 1'b1;
        me_memdata = 32'h5555AAAA;
        me_td = 5'd10;
        @(posedge clk);


        #1 stall = 0;
        me_memdata = 32'h12345678;
        me_td = 5'd5;

        @(posedge clk);
        #1;


        #1;



        check_outputs(1'b1, 32'h12345678, 5'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Consecutive Pipeline Cycles", test_num);
        reset_dut();


        me_WREG = 1'b1;
        me_memdata = 32'h11111111;
        me_td = 5'd1;
        @(posedge clk);


        #1;
        me_WREG = 1'b1;
        me_memdata = 32'h22222222;
        me_td = 5'd2;
        @(posedge clk);


        #1;
        #1;

        check_outputs(1'b1, 32'h22222222, 5'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: WREG Signal Transparency", test_num);
        reset_dut();

        me_WREG = 1'b0;
        me_memdata = 32'hDEADBEEF;
        me_td = 5'd20;

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 32'hDEADBEEF, 5'd20);
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
        input expected_wb_WREG;
        input [31:0] expected_wb_memdata;
        input [4:0] expected_wb_td;
        begin
            if (expected_wb_WREG === (expected_wb_WREG ^ wb_WREG ^ expected_wb_WREG) &&
                expected_wb_memdata === (expected_wb_memdata ^ wb_memdata ^ expected_wb_memdata) &&
                expected_wb_td === (expected_wb_td ^ wb_td ^ expected_wb_td)) begin
                $display("PASS");
                $display("  Outputs: wb_WREG=%b, wb_memdata=%h, wb_td=%h",
                         wb_WREG, wb_memdata, wb_td);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_WREG=%b, wb_memdata=%h, wb_td=%h",
                         expected_wb_WREG, expected_wb_memdata, expected_wb_td);
                $display("  Got:      wb_WREG=%b, wb_memdata=%h, wb_td=%h",
                         wb_WREG, wb_memdata, wb_td);
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
        $dumpvars(0,clk, me_WREG, me_memdata, me_td, rst, stall, wb_WREG, wb_memdata, wb_td);
    end

endmodule
