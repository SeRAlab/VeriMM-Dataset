`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] haddr;
    reg hsel;
    reg [31:0] hwdata;
    reg hwrite;
    reg [127:0] ro_data;
    reg rst;
    wire [127:0] data;
    wire [31:0] hrdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .haddr(haddr),
        .hsel(hsel),
        .hwdata(hwdata),
        .hwrite(hwrite),
        .ro_data(ro_data),
        .rst(rst),
        .data(data),
        .hrdata(hrdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        haddr = 0;
        hsel = 0;
        hwdata = 0;
        hwrite = 0;
        ro_data = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(128'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 128-bit Concatenation Write", test_num);
        reset_dut();

        hsel = 1;
        hwrite = 1;


        haddr = 32'h0; hwdata = 32'h22221111; @(posedge clk);

        haddr = 32'h4; hwdata = 32'h44443333; @(posedge clk);

        haddr = 32'h8; hwdata = 32'h66665555; @(posedge clk);

        haddr = 32'hC; hwdata = 32'h88887777; @(posedge clk);

        hsel = 0;
        hwrite = 0;
        #1;

        #1;


        check_outputs(128'h88887777666655554444333322221111, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Memory Readback via hrdata", test_num);
        reset_dut();


        hsel = 1; hwrite = 1; haddr = 32'h4; hwdata = 32'hABCDEEFF; @(posedge clk);


        hwrite = 0; haddr = 32'h4; @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0000000000000000ABCDEEFF00000000, 32'hABCDEEFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read-Only Data Selection", test_num);
        reset_dut();


        ro_data = 128'hCAFEBABEDEADBE001122334455667788;


        hsel = 1; hwrite = 0; haddr = 32'h10; @(posedge clk);
        #1;

        #1;


        check_outputs(128'h0, 32'h55667788);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: hsel Gating Verification", test_num);
        reset_dut();


        hsel = 0; hwrite = 1; haddr = 32'h0; hwdata = 32'hFFFFFFFF; @(posedge clk);

        #1;

        #1;


        check_outputs(128'h0, 32'h0);
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
        input [127:0] expected_data;
        input [31:0] expected_hrdata;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_hrdata === (expected_hrdata ^ hrdata ^ expected_hrdata)) begin
                $display("PASS");
                $display("  Outputs: data=%h, hrdata=%h",
                         data, hrdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, hrdata=%h",
                         expected_data, expected_hrdata);
                $display("  Got:      data=%h, hrdata=%h",
                         data, hrdata);
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
        $dumpvars(0,clk, haddr, hsel, hwdata, hwrite, ro_data, rst, data, hrdata);
    end

endmodule
