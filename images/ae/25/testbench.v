`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg AXI4_Lite_ACLK;
    reg [15:0] AXI4_Lite_ARADDR;
    reg AXI4_Lite_ARESETN;
    reg AXI4_Lite_ARVALID;
    reg [15:0] AXI4_Lite_AWADDR;
    reg AXI4_Lite_AWVALID;
    reg AXI4_Lite_BREADY;
    reg AXI4_Lite_RREADY;
    reg [31:0] AXI4_Lite_WDATA;
    reg [3:0] AXI4_Lite_WSTRB;
    reg AXI4_Lite_WVALID;
    reg IPCORE_CLK;
    reg IPCORE_RESETN;
    wire AXI4_Lite_ARREADY;
    wire AXI4_Lite_AWREADY;
    wire [1:0] AXI4_Lite_BRESP;
    wire AXI4_Lite_BVALID;
    wire [31:0] AXI4_Lite_RDATA;
    wire [1:0] AXI4_Lite_RRESP;
    wire AXI4_Lite_RVALID;
    wire AXI4_Lite_WREADY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AXI4_Lite_ACLK(AXI4_Lite_ACLK),
        .AXI4_Lite_ARADDR(AXI4_Lite_ARADDR),
        .AXI4_Lite_ARESETN(AXI4_Lite_ARESETN),
        .AXI4_Lite_ARVALID(AXI4_Lite_ARVALID),
        .AXI4_Lite_AWADDR(AXI4_Lite_AWADDR),
        .AXI4_Lite_AWVALID(AXI4_Lite_AWVALID),
        .AXI4_Lite_BREADY(AXI4_Lite_BREADY),
        .AXI4_Lite_RREADY(AXI4_Lite_RREADY),
        .AXI4_Lite_WDATA(AXI4_Lite_WDATA),
        .AXI4_Lite_WSTRB(AXI4_Lite_WSTRB),
        .AXI4_Lite_WVALID(AXI4_Lite_WVALID),
        .IPCORE_CLK(IPCORE_CLK),
        .IPCORE_RESETN(IPCORE_RESETN),
        .AXI4_Lite_ARREADY(AXI4_Lite_ARREADY),
        .AXI4_Lite_AWREADY(AXI4_Lite_AWREADY),
        .AXI4_Lite_BRESP(AXI4_Lite_BRESP),
        .AXI4_Lite_BVALID(AXI4_Lite_BVALID),
        .AXI4_Lite_RDATA(AXI4_Lite_RDATA),
        .AXI4_Lite_RRESP(AXI4_Lite_RRESP),
        .AXI4_Lite_RVALID(AXI4_Lite_RVALID),
        .AXI4_Lite_WREADY(AXI4_Lite_WREADY)
    );
    task reset_signals;

        begin
            IPCORE_RESETN = 0;
            AXI4_Lite_ARESETN = 0;
            AXI4_Lite_AWADDR = 0;
            AXI4_Lite_AWVALID = 0;
            AXI4_Lite_WDATA = 0;
            AXI4_Lite_WSTRB = 0;
            AXI4_Lite_WVALID = 0;
            AXI4_Lite_BREADY = 0;
            AXI4_Lite_ARADDR = 0;
            AXI4_Lite_ARVALID = 0;
            AXI4_Lite_RREADY = 0;
            repeat(2) @(posedge AXI4_Lite_ACLK);
            IPCORE_RESETN = 1;
            AXI4_Lite_ARESETN = 1;
            @(posedge AXI4_Lite_ACLK);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset State Behavior");
            reset_signals();

            #1;


            check_outputs(1'b0, 1'b0, 2'b00, 1'b0, 32'h0, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Simple Write Transaction");
            reset_signals();
            AXI4_Lite_AWADDR = 16'h1234;
            AXI4_Lite_AWVALID = 1;
            AXI4_Lite_WDATA = 32'hDEADBEEF;
            AXI4_Lite_WSTRB = 4'hF;
            AXI4_Lite_WVALID = 1;
            AXI4_Lite_BREADY = 1;
            repeat(1) @(posedge AXI4_Lite_ACLK);


            #1;



            check_outputs(1'b0, 1'b1, 2'b00, 1'b1, 32'h0, 2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Simple Read Transaction");
            reset_signals();
            AXI4_Lite_ARADDR = 16'h5678;
            AXI4_Lite_ARVALID = 1;
            AXI4_Lite_RREADY = 1;
            repeat(1) @(posedge AXI4_Lite_ACLK);

            #1;


            check_outputs(1'b1, 1'b0, 2'b00, 1'b0, 32'h0, 2'b00, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Concurrent Read and Write");
            reset_signals();
            AXI4_Lite_AWADDR = 16'hAAAA;
            AXI4_Lite_AWVALID = 1;
            AXI4_Lite_WDATA = 32'h11112222;
            AXI4_Lite_WVALID = 1;
            AXI4_Lite_BREADY = 1;
            AXI4_Lite_ARADDR = 16'hBBBB;
            AXI4_Lite_ARVALID = 1;
            AXI4_Lite_RREADY = 1;
            repeat(1) @(posedge AXI4_Lite_ACLK);

            #1;


            check_outputs(1'b1, 1'b1, 2'b00, 1'b1, 32'h0, 2'b00, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Write with Partial Strobe");
            reset_signals();
            AXI4_Lite_AWADDR = 16'h0004;
            AXI4_Lite_AWVALID = 1;
            AXI4_Lite_WDATA = 32'hCAFEFACE;
            AXI4_Lite_WSTRB = 4'b0001;
            AXI4_Lite_WVALID = 1;
            AXI4_Lite_BREADY = 1;
            repeat(1) @(posedge AXI4_Lite_ACLK);

            #1;


            check_outputs(1'b0, 1'b1, 2'b00, 1'b1, 32'h0, 2'b00, 1'b0, 1'b1);
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
        input expected_AXI4_Lite_ARREADY;
        input expected_AXI4_Lite_AWREADY;
        input [1:0] expected_AXI4_Lite_BRESP;
        input expected_AXI4_Lite_BVALID;
        input [31:0] expected_AXI4_Lite_RDATA;
        input [1:0] expected_AXI4_Lite_RRESP;
        input expected_AXI4_Lite_RVALID;
        input expected_AXI4_Lite_WREADY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AXI4_Lite_ARREADY === (expected_AXI4_Lite_ARREADY ^ AXI4_Lite_ARREADY ^ expected_AXI4_Lite_ARREADY) &&
                expected_AXI4_Lite_AWREADY === (expected_AXI4_Lite_AWREADY ^ AXI4_Lite_AWREADY ^ expected_AXI4_Lite_AWREADY) &&
                expected_AXI4_Lite_BRESP === (expected_AXI4_Lite_BRESP ^ AXI4_Lite_BRESP ^ expected_AXI4_Lite_BRESP) &&
                expected_AXI4_Lite_BVALID === (expected_AXI4_Lite_BVALID ^ AXI4_Lite_BVALID ^ expected_AXI4_Lite_BVALID) &&
                expected_AXI4_Lite_RDATA === (expected_AXI4_Lite_RDATA ^ AXI4_Lite_RDATA ^ expected_AXI4_Lite_RDATA) &&
                expected_AXI4_Lite_RRESP === (expected_AXI4_Lite_RRESP ^ AXI4_Lite_RRESP ^ expected_AXI4_Lite_RRESP) &&
                expected_AXI4_Lite_RVALID === (expected_AXI4_Lite_RVALID ^ AXI4_Lite_RVALID ^ expected_AXI4_Lite_RVALID) &&
                expected_AXI4_Lite_WREADY === (expected_AXI4_Lite_WREADY ^ AXI4_Lite_WREADY ^ expected_AXI4_Lite_WREADY)) begin
                $display("PASS");
                $display("  Outputs: AXI4_Lite_ARREADY=%b, AXI4_Lite_AWREADY=%b, AXI4_Lite_BRESP=%h, AXI4_Lite_BVALID=%b, AXI4_Lite_RDATA=%h, AXI4_Lite_RRESP=%h, AXI4_Lite_RVALID=%b, AXI4_Lite_WREADY=%b",
                         AXI4_Lite_ARREADY, AXI4_Lite_AWREADY, AXI4_Lite_BRESP, AXI4_Lite_BVALID, AXI4_Lite_RDATA, AXI4_Lite_RRESP, AXI4_Lite_RVALID, AXI4_Lite_WREADY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AXI4_Lite_ARREADY=%b, AXI4_Lite_AWREADY=%b, AXI4_Lite_BRESP=%h, AXI4_Lite_BVALID=%b, AXI4_Lite_RDATA=%h, AXI4_Lite_RRESP=%h, AXI4_Lite_RVALID=%b, AXI4_Lite_WREADY=%b",
                         expected_AXI4_Lite_ARREADY, expected_AXI4_Lite_AWREADY, expected_AXI4_Lite_BRESP, expected_AXI4_Lite_BVALID, expected_AXI4_Lite_RDATA, expected_AXI4_Lite_RRESP, expected_AXI4_Lite_RVALID, expected_AXI4_Lite_WREADY);
                $display("  Got:      AXI4_Lite_ARREADY=%b, AXI4_Lite_AWREADY=%b, AXI4_Lite_BRESP=%h, AXI4_Lite_BVALID=%b, AXI4_Lite_RDATA=%h, AXI4_Lite_RRESP=%h, AXI4_Lite_RVALID=%b, AXI4_Lite_WREADY=%b",
                         AXI4_Lite_ARREADY, AXI4_Lite_AWREADY, AXI4_Lite_BRESP, AXI4_Lite_BVALID, AXI4_Lite_RDATA, AXI4_Lite_RRESP, AXI4_Lite_RVALID, AXI4_Lite_WREADY);
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
