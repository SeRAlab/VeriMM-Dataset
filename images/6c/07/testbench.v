`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg M2S_AXI_ARREADY;
    reg M2S_AXI_AWREADY;
    reg [1:0] M2S_AXI_BRESP;
    reg M2S_AXI_BVALID;
    reg [63:0] M2S_AXI_RDATA;
    reg M2S_AXI_RLAST;
    reg [1:0] M2S_AXI_RRESP;
    reg M2S_AXI_RVALID;
    reg M2S_AXI_WREADY;
    wire M2S_AXI_ACLK;
    wire [31:0] M2S_AXI_ARADDR;
    wire [1:0] M2S_AXI_ARBURST;
    wire [3:0] M2S_AXI_ARLEN;
    wire [1:0] M2S_AXI_ARSIZE;
    wire M2S_AXI_ARVALID;
    wire [31:0] M2S_AXI_AWADDR;
    wire [1:0] M2S_AXI_AWBURST;
    wire [3:0] M2S_AXI_AWLEN;
    wire [1:0] M2S_AXI_AWSIZE;
    wire M2S_AXI_AWVALID;
    wire M2S_AXI_BREADY;
    wire M2S_AXI_RREADY;
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
        .M2S_AXI_ARREADY(M2S_AXI_ARREADY),
        .M2S_AXI_AWREADY(M2S_AXI_AWREADY),
        .M2S_AXI_BRESP(M2S_AXI_BRESP),
        .M2S_AXI_BVALID(M2S_AXI_BVALID),
        .M2S_AXI_RDATA(M2S_AXI_RDATA),
        .M2S_AXI_RLAST(M2S_AXI_RLAST),
        .M2S_AXI_RRESP(M2S_AXI_RRESP),
        .M2S_AXI_RVALID(M2S_AXI_RVALID),
        .M2S_AXI_WREADY(M2S_AXI_WREADY),
        .M2S_AXI_ACLK(M2S_AXI_ACLK),
        .M2S_AXI_ARADDR(M2S_AXI_ARADDR),
        .M2S_AXI_ARBURST(M2S_AXI_ARBURST),
        .M2S_AXI_ARLEN(M2S_AXI_ARLEN),
        .M2S_AXI_ARSIZE(M2S_AXI_ARSIZE),
        .M2S_AXI_ARVALID(M2S_AXI_ARVALID),
        .M2S_AXI_AWADDR(M2S_AXI_AWADDR),
        .M2S_AXI_AWBURST(M2S_AXI_AWBURST),
        .M2S_AXI_AWLEN(M2S_AXI_AWLEN),
        .M2S_AXI_AWSIZE(M2S_AXI_AWSIZE),
        .M2S_AXI_AWVALID(M2S_AXI_AWVALID),
        .M2S_AXI_BREADY(M2S_AXI_BREADY),
        .M2S_AXI_RREADY(M2S_AXI_RREADY),
        .M2S_AXI_WDATA(M2S_AXI_WDATA),
        .M2S_AXI_WLAST(M2S_AXI_WLAST),
        .M2S_AXI_WSTRB(M2S_AXI_WSTRB),
        .M2S_AXI_WVALID(M2S_AXI_WVALID)
    );
    task testcase001;

        begin
            $display("Testcase 001: Initial Idle State - All inputs 0");
            test_num = test_num + 1;


            M2S_AXI_ARREADY = 1'b0;
            M2S_AXI_AWREADY = 1'b0;
            M2S_AXI_BRESP   = 2'b00;
            M2S_AXI_BVALID  = 1'b0;
            M2S_AXI_RDATA   = 64'h0;
            M2S_AXI_RLAST   = 1'b0;
            M2S_AXI_RRESP   = 2'b00;
            M2S_AXI_RVALID  = 1'b0;
            M2S_AXI_WREADY  = 1'b0;


            #1;



            check_outputs(
                1'b0,
                32'h0,
                2'b00,
                4'h0,
                2'b00,
                1'b0,
                32'h0,
                2'b00,
                4'h0,
                2'b00,
                1'b0,
                1'b0,
                1'b0,
                64'h0,
                1'b0,
                8'h0,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Stimulate Read Channel Inputs");
            test_num = test_num + 1;


            M2S_AXI_ARREADY = 1'b1;
            M2S_AXI_RVALID  = 1'b1;
            M2S_AXI_RDATA   = 64'hABCDEFFEDCBA9876;
            M2S_AXI_RLAST   = 1'b1;
            M2S_AXI_RRESP   = 2'b00;


            #1;



            check_outputs(
                1'b0, 32'h0, 2'b00, 4'h0, 2'b00, 1'b0,
                32'h0, 2'b00, 4'h0, 2'b00, 1'b0, 1'b0, 1'b0,
                64'h0, 1'b0, 8'h0, 1'b0
            );
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Stimulate Write Channel Inputs");
            test_num = test_num + 1;


            M2S_AXI_AWREADY = 1'b1;
            M2S_AXI_WREADY  = 1'b1;
            M2S_AXI_BVALID  = 1'b1;
            M2S_AXI_BRESP   = 2'b10;


            #1;



            check_outputs(
                1'b0, 32'h0, 2'b00, 4'h0, 2'b00, 1'b0,
                32'h0, 2'b00, 4'h0, 2'b00, 1'b0, 1'b0, 1'b0,
                64'h0, 1'b0, 8'h0, 1'b0
            );
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All Inputs Active High");
            test_num = test_num + 1;


            M2S_AXI_ARREADY = 1'b1;
            M2S_AXI_AWREADY = 1'b1;
            M2S_AXI_BRESP   = 2'b11;
            M2S_AXI_BVALID  = 1'b1;
            M2S_AXI_RDATA   = 64'hFFFFFFFFFFFFFFFF;
            M2S_AXI_RLAST   = 1'b1;
            M2S_AXI_RRESP   = 2'b11;
            M2S_AXI_RVALID  = 1'b1;
            M2S_AXI_WREADY  = 1'b1;


            #1;



            check_outputs(
                1'b0, 32'h0, 2'b00, 4'h0, 2'b00, 1'b0,
                32'h0, 2'b00, 4'h0, 2'b00, 1'b0, 1'b0, 1'b0,
                64'h0, 1'b0, 8'h0, 1'b0
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
        testcase004();
        
        
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
        input [31:0] expected_M2S_AXI_ARADDR;
        input [1:0] expected_M2S_AXI_ARBURST;
        input [3:0] expected_M2S_AXI_ARLEN;
        input [1:0] expected_M2S_AXI_ARSIZE;
        input expected_M2S_AXI_ARVALID;
        input [31:0] expected_M2S_AXI_AWADDR;
        input [1:0] expected_M2S_AXI_AWBURST;
        input [3:0] expected_M2S_AXI_AWLEN;
        input [1:0] expected_M2S_AXI_AWSIZE;
        input expected_M2S_AXI_AWVALID;
        input expected_M2S_AXI_BREADY;
        input expected_M2S_AXI_RREADY;
        input [63:0] expected_M2S_AXI_WDATA;
        input expected_M2S_AXI_WLAST;
        input [7:0] expected_M2S_AXI_WSTRB;
        input expected_M2S_AXI_WVALID;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M2S_AXI_ACLK === (expected_M2S_AXI_ACLK ^ M2S_AXI_ACLK ^ expected_M2S_AXI_ACLK) &&
                expected_M2S_AXI_ARADDR === (expected_M2S_AXI_ARADDR ^ M2S_AXI_ARADDR ^ expected_M2S_AXI_ARADDR) &&
                expected_M2S_AXI_ARBURST === (expected_M2S_AXI_ARBURST ^ M2S_AXI_ARBURST ^ expected_M2S_AXI_ARBURST) &&
                expected_M2S_AXI_ARLEN === (expected_M2S_AXI_ARLEN ^ M2S_AXI_ARLEN ^ expected_M2S_AXI_ARLEN) &&
                expected_M2S_AXI_ARSIZE === (expected_M2S_AXI_ARSIZE ^ M2S_AXI_ARSIZE ^ expected_M2S_AXI_ARSIZE) &&
                expected_M2S_AXI_ARVALID === (expected_M2S_AXI_ARVALID ^ M2S_AXI_ARVALID ^ expected_M2S_AXI_ARVALID) &&
                expected_M2S_AXI_AWADDR === (expected_M2S_AXI_AWADDR ^ M2S_AXI_AWADDR ^ expected_M2S_AXI_AWADDR) &&
                expected_M2S_AXI_AWBURST === (expected_M2S_AXI_AWBURST ^ M2S_AXI_AWBURST ^ expected_M2S_AXI_AWBURST) &&
                expected_M2S_AXI_AWLEN === (expected_M2S_AXI_AWLEN ^ M2S_AXI_AWLEN ^ expected_M2S_AXI_AWLEN) &&
                expected_M2S_AXI_AWSIZE === (expected_M2S_AXI_AWSIZE ^ M2S_AXI_AWSIZE ^ expected_M2S_AXI_AWSIZE) &&
                expected_M2S_AXI_AWVALID === (expected_M2S_AXI_AWVALID ^ M2S_AXI_AWVALID ^ expected_M2S_AXI_AWVALID) &&
                expected_M2S_AXI_BREADY === (expected_M2S_AXI_BREADY ^ M2S_AXI_BREADY ^ expected_M2S_AXI_BREADY) &&
                expected_M2S_AXI_RREADY === (expected_M2S_AXI_RREADY ^ M2S_AXI_RREADY ^ expected_M2S_AXI_RREADY) &&
                expected_M2S_AXI_WDATA === (expected_M2S_AXI_WDATA ^ M2S_AXI_WDATA ^ expected_M2S_AXI_WDATA) &&
                expected_M2S_AXI_WLAST === (expected_M2S_AXI_WLAST ^ M2S_AXI_WLAST ^ expected_M2S_AXI_WLAST) &&
                expected_M2S_AXI_WSTRB === (expected_M2S_AXI_WSTRB ^ M2S_AXI_WSTRB ^ expected_M2S_AXI_WSTRB) &&
                expected_M2S_AXI_WVALID === (expected_M2S_AXI_WVALID ^ M2S_AXI_WVALID ^ expected_M2S_AXI_WVALID)) begin
                $display("PASS");
                $display("  Outputs: M2S_AXI_ACLK=%b, M2S_AXI_ARADDR=%h, M2S_AXI_ARBURST=%h, M2S_AXI_ARLEN=%h, M2S_AXI_ARSIZE=%h, M2S_AXI_ARVALID=%b, M2S_AXI_AWADDR=%h, M2S_AXI_AWBURST=%h, M2S_AXI_AWLEN=%h, M2S_AXI_AWSIZE=%h, M2S_AXI_AWVALID=%b, M2S_AXI_BREADY=%b, M2S_AXI_RREADY=%b, M2S_AXI_WDATA=%h, M2S_AXI_WLAST=%b, M2S_AXI_WSTRB=%h, M2S_AXI_WVALID=%b",
                         M2S_AXI_ACLK, M2S_AXI_ARADDR, M2S_AXI_ARBURST, M2S_AXI_ARLEN, M2S_AXI_ARSIZE, M2S_AXI_ARVALID, M2S_AXI_AWADDR, M2S_AXI_AWBURST, M2S_AXI_AWLEN, M2S_AXI_AWSIZE, M2S_AXI_AWVALID, M2S_AXI_BREADY, M2S_AXI_RREADY, M2S_AXI_WDATA, M2S_AXI_WLAST, M2S_AXI_WSTRB, M2S_AXI_WVALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M2S_AXI_ACLK=%b, M2S_AXI_ARADDR=%h, M2S_AXI_ARBURST=%h, M2S_AXI_ARLEN=%h, M2S_AXI_ARSIZE=%h, M2S_AXI_ARVALID=%b, M2S_AXI_AWADDR=%h, M2S_AXI_AWBURST=%h, M2S_AXI_AWLEN=%h, M2S_AXI_AWSIZE=%h, M2S_AXI_AWVALID=%b, M2S_AXI_BREADY=%b, M2S_AXI_RREADY=%b, M2S_AXI_WDATA=%h, M2S_AXI_WLAST=%b, M2S_AXI_WSTRB=%h, M2S_AXI_WVALID=%b",
                         expected_M2S_AXI_ACLK, expected_M2S_AXI_ARADDR, expected_M2S_AXI_ARBURST, expected_M2S_AXI_ARLEN, expected_M2S_AXI_ARSIZE, expected_M2S_AXI_ARVALID, expected_M2S_AXI_AWADDR, expected_M2S_AXI_AWBURST, expected_M2S_AXI_AWLEN, expected_M2S_AXI_AWSIZE, expected_M2S_AXI_AWVALID, expected_M2S_AXI_BREADY, expected_M2S_AXI_RREADY, expected_M2S_AXI_WDATA, expected_M2S_AXI_WLAST, expected_M2S_AXI_WSTRB, expected_M2S_AXI_WVALID);
                $display("  Got:      M2S_AXI_ACLK=%b, M2S_AXI_ARADDR=%h, M2S_AXI_ARBURST=%h, M2S_AXI_ARLEN=%h, M2S_AXI_ARSIZE=%h, M2S_AXI_ARVALID=%b, M2S_AXI_AWADDR=%h, M2S_AXI_AWBURST=%h, M2S_AXI_AWLEN=%h, M2S_AXI_AWSIZE=%h, M2S_AXI_AWVALID=%b, M2S_AXI_BREADY=%b, M2S_AXI_RREADY=%b, M2S_AXI_WDATA=%h, M2S_AXI_WLAST=%b, M2S_AXI_WSTRB=%h, M2S_AXI_WVALID=%b",
                         M2S_AXI_ACLK, M2S_AXI_ARADDR, M2S_AXI_ARBURST, M2S_AXI_ARLEN, M2S_AXI_ARSIZE, M2S_AXI_ARVALID, M2S_AXI_AWADDR, M2S_AXI_AWBURST, M2S_AXI_AWLEN, M2S_AXI_AWSIZE, M2S_AXI_AWVALID, M2S_AXI_BREADY, M2S_AXI_RREADY, M2S_AXI_WDATA, M2S_AXI_WLAST, M2S_AXI_WSTRB, M2S_AXI_WVALID);
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
