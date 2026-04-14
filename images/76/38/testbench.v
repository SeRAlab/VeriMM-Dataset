`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg M2S_AXI_AWREADY;
    reg [1:0] M2S_AXI_BRESP;
    reg M2S_AXI_BVALID;
    reg M2S_AXI_WREADY;
    wire M2S_AXI_ACLK;
    wire [31:0] M2S_AXI_AWADDR;
    wire [1:0] M2S_AXI_AWBURST;
    wire [3:0] M2S_AXI_AWLEN;
    wire [1:0] M2S_AXI_AWSIZE;
    wire M2S_AXI_AWVALID;
    wire M2S_AXI_BREADY;
    wire [63:0] M2S_AXI_WDATA;
    wire M2S_AXI_WLAST;
    wire [7:0] M2S_AXI_WSTRB;
    wire M2S_AXI_WVALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M2S_AXI_AWREADY(M2S_AXI_AWREADY),
        .M2S_AXI_BRESP(M2S_AXI_BRESP),
        .M2S_AXI_BVALID(M2S_AXI_BVALID),
        .M2S_AXI_WREADY(M2S_AXI_WREADY),
        .M2S_AXI_ACLK(M2S_AXI_ACLK),
        .M2S_AXI_AWADDR(M2S_AXI_AWADDR),
        .M2S_AXI_AWBURST(M2S_AXI_AWBURST),
        .M2S_AXI_AWLEN(M2S_AXI_AWLEN),
        .M2S_AXI_AWSIZE(M2S_AXI_AWSIZE),
        .M2S_AXI_AWVALID(M2S_AXI_AWVALID),
        .M2S_AXI_BREADY(M2S_AXI_BREADY),
        .M2S_AXI_WDATA(M2S_AXI_WDATA),
        .M2S_AXI_WLAST(M2S_AXI_WLAST),
        .M2S_AXI_WSTRB(M2S_AXI_WSTRB),
        .M2S_AXI_WVALID(M2S_AXI_WVALID)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Single-Beat Write Transaction");


            M2S_AXI_AWREADY = 0;
            M2S_AXI_WREADY = 0;
            M2S_AXI_BVALID = 0;
            M2S_AXI_BRESP = 2'b00;


            wait(M2S_AXI_AWVALID === 1'b1);
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_AWREADY = 1'b1;
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_AWREADY = 1'b0;


            wait(M2S_AXI_WVALID === 1'b1);
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_WREADY = 1'b1;


            wait(M2S_AXI_WLAST === 1'b1 && M2S_AXI_WVALID === 1'b1);
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_WREADY = 1'b0;


            @(posedge M2S_AXI_ACLK);
            #1;
            M2S_AXI_BVALID = 1'b1;
            M2S_AXI_BRESP = 2'b00;


            wait(M2S_AXI_BREADY === 1'b1);
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_BVALID = 1'b0;


            #1;



            check_outputs(
                M2S_AXI_ACLK, M2S_AXI_AWADDR, M2S_AXI_AWBURST, M2S_AXI_AWLEN, M2S_AXI_AWSIZE,
                1'b0,
                1'b0,
                M2S_AXI_WDATA, 1'b0, M2S_AXI_WSTRB,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Write Transaction with Slave Wait States");


            M2S_AXI_AWREADY = 0;
            M2S_AXI_WREADY = 0;
            M2S_AXI_BVALID = 0;


            wait(M2S_AXI_AWVALID === 1'b1);
            repeat(3) @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_AWREADY = 1'b1;
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_AWREADY = 1'b0;


            wait(M2S_AXI_WVALID === 1'b1);
            repeat(2) @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_WREADY = 1'b1;

            wait(M2S_AXI_WLAST === 1'b1);
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_WREADY = 1'b0;


            repeat(2) @(posedge M2S_AXI_ACLK);
            #1;
            M2S_AXI_BVALID = 1'b1;
            M2S_AXI_BRESP = 2'b00;
            wait(M2S_AXI_BREADY === 1'b1);
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_BVALID = 1'b0;


            #1;



            check_outputs(
                M2S_AXI_ACLK, M2S_AXI_AWADDR, M2S_AXI_AWBURST, M2S_AXI_AWLEN, M2S_AXI_AWSIZE,
                1'b0, 1'b0, M2S_AXI_WDATA, 1'b0, M2S_AXI_WSTRB, 1'b0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Check Write Response Error Handling");


            M2S_AXI_AWREADY = 0;
            M2S_AXI_WREADY = 0;
            M2S_AXI_BVALID = 0;


            wait(M2S_AXI_AWVALID === 1'b1);
            #1 M2S_AXI_AWREADY = 1'b1;
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_AWREADY = 1'b0;

            wait(M2S_AXI_WVALID === 1'b1);
            #1 M2S_AXI_WREADY = 1'b1;
            wait(M2S_AXI_WLAST === 1'b1);
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_WREADY = 1'b0;


            @(posedge M2S_AXI_ACLK);
            #1;
            M2S_AXI_BVALID = 1'b1;
            M2S_AXI_BRESP = 2'b10;

            wait(M2S_AXI_BREADY === 1'b1);
            @(posedge M2S_AXI_ACLK);
            #1 M2S_AXI_BVALID = 1'b0;


            #1;



            check_outputs(
                M2S_AXI_ACLK, M2S_AXI_AWADDR, M2S_AXI_AWBURST, M2S_AXI_AWLEN, M2S_AXI_AWSIZE,
                1'b0, 1'b0, M2S_AXI_WDATA, 1'b0, M2S_AXI_WSTRB, 1'b0
            );
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
        input expected_M2S_AXI_ACLK;
        input [31:0] expected_M2S_AXI_AWADDR;
        input [1:0] expected_M2S_AXI_AWBURST;
        input [3:0] expected_M2S_AXI_AWLEN;
        input [1:0] expected_M2S_AXI_AWSIZE;
        input expected_M2S_AXI_AWVALID;
        input expected_M2S_AXI_BREADY;
        input [63:0] expected_M2S_AXI_WDATA;
        input expected_M2S_AXI_WLAST;
        input [7:0] expected_M2S_AXI_WSTRB;
        input expected_M2S_AXI_WVALID;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M2S_AXI_ACLK === (expected_M2S_AXI_ACLK ^ M2S_AXI_ACLK ^ expected_M2S_AXI_ACLK) &&
                expected_M2S_AXI_AWADDR === (expected_M2S_AXI_AWADDR ^ M2S_AXI_AWADDR ^ expected_M2S_AXI_AWADDR) &&
                expected_M2S_AXI_AWBURST === (expected_M2S_AXI_AWBURST ^ M2S_AXI_AWBURST ^ expected_M2S_AXI_AWBURST) &&
                expected_M2S_AXI_AWLEN === (expected_M2S_AXI_AWLEN ^ M2S_AXI_AWLEN ^ expected_M2S_AXI_AWLEN) &&
                expected_M2S_AXI_AWSIZE === (expected_M2S_AXI_AWSIZE ^ M2S_AXI_AWSIZE ^ expected_M2S_AXI_AWSIZE) &&
                expected_M2S_AXI_AWVALID === (expected_M2S_AXI_AWVALID ^ M2S_AXI_AWVALID ^ expected_M2S_AXI_AWVALID) &&
                expected_M2S_AXI_BREADY === (expected_M2S_AXI_BREADY ^ M2S_AXI_BREADY ^ expected_M2S_AXI_BREADY) &&
                expected_M2S_AXI_WDATA === (expected_M2S_AXI_WDATA ^ M2S_AXI_WDATA ^ expected_M2S_AXI_WDATA) &&
                expected_M2S_AXI_WLAST === (expected_M2S_AXI_WLAST ^ M2S_AXI_WLAST ^ expected_M2S_AXI_WLAST) &&
                expected_M2S_AXI_WSTRB === (expected_M2S_AXI_WSTRB ^ M2S_AXI_WSTRB ^ expected_M2S_AXI_WSTRB) &&
                expected_M2S_AXI_WVALID === (expected_M2S_AXI_WVALID ^ M2S_AXI_WVALID ^ expected_M2S_AXI_WVALID)) begin
                $display("PASS");
                $display("  Outputs: M2S_AXI_ACLK=%b, M2S_AXI_AWADDR=%h, M2S_AXI_AWBURST=%h, M2S_AXI_AWLEN=%h, M2S_AXI_AWSIZE=%h, M2S_AXI_AWVALID=%b, M2S_AXI_BREADY=%b, M2S_AXI_WDATA=%h, M2S_AXI_WLAST=%b, M2S_AXI_WSTRB=%h, M2S_AXI_WVALID=%b",
                         M2S_AXI_ACLK, M2S_AXI_AWADDR, M2S_AXI_AWBURST, M2S_AXI_AWLEN, M2S_AXI_AWSIZE, M2S_AXI_AWVALID, M2S_AXI_BREADY, M2S_AXI_WDATA, M2S_AXI_WLAST, M2S_AXI_WSTRB, M2S_AXI_WVALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M2S_AXI_ACLK=%b, M2S_AXI_AWADDR=%h, M2S_AXI_AWBURST=%h, M2S_AXI_AWLEN=%h, M2S_AXI_AWSIZE=%h, M2S_AXI_AWVALID=%b, M2S_AXI_BREADY=%b, M2S_AXI_WDATA=%h, M2S_AXI_WLAST=%b, M2S_AXI_WSTRB=%h, M2S_AXI_WVALID=%b",
                         expected_M2S_AXI_ACLK, expected_M2S_AXI_AWADDR, expected_M2S_AXI_AWBURST, expected_M2S_AXI_AWLEN, expected_M2S_AXI_AWSIZE, expected_M2S_AXI_AWVALID, expected_M2S_AXI_BREADY, expected_M2S_AXI_WDATA, expected_M2S_AXI_WLAST, expected_M2S_AXI_WSTRB, expected_M2S_AXI_WVALID);
                $display("  Got:      M2S_AXI_ACLK=%b, M2S_AXI_AWADDR=%h, M2S_AXI_AWBURST=%h, M2S_AXI_AWLEN=%h, M2S_AXI_AWSIZE=%h, M2S_AXI_AWVALID=%b, M2S_AXI_BREADY=%b, M2S_AXI_WDATA=%h, M2S_AXI_WLAST=%b, M2S_AXI_WSTRB=%h, M2S_AXI_WVALID=%b",
                         M2S_AXI_ACLK, M2S_AXI_AWADDR, M2S_AXI_AWBURST, M2S_AXI_AWLEN, M2S_AXI_AWSIZE, M2S_AXI_AWVALID, M2S_AXI_BREADY, M2S_AXI_WDATA, M2S_AXI_WLAST, M2S_AXI_WSTRB, M2S_AXI_WVALID);
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

endmodule
