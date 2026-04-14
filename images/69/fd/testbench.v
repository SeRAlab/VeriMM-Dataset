`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] S2M_AXI_ARADDR;
    reg [11:0] S2M_AXI_ARID;
    reg S2M_AXI_ARVALID;
    reg [31:0] S2M_AXI_AWADDR;
    reg [11:0] S2M_AXI_AWID;
    reg S2M_AXI_AWVALID;
    reg S2M_AXI_BREADY;
    reg S2M_AXI_RREADY;
    reg [31:0] S2M_AXI_WDATA;
    reg [3:0] S2M_AXI_WSTRB;
    reg S2M_AXI_WVALID;
    wire S2M_AXI_ACLK;
    wire S2M_AXI_ARREADY;
    wire S2M_AXI_AWREADY;
    wire [11:0] S2M_AXI_BID;
    wire [1:0] S2M_AXI_BRESP;
    wire S2M_AXI_BVALID;
    wire [31:0] S2M_AXI_RDATA;
    wire [11:0] S2M_AXI_RID;
    wire S2M_AXI_RLAST;
    wire [1:0] S2M_AXI_RRESP;
    wire S2M_AXI_RVALID;
    wire S2M_AXI_WREADY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S2M_AXI_ARADDR(S2M_AXI_ARADDR),
        .S2M_AXI_ARID(S2M_AXI_ARID),
        .S2M_AXI_ARVALID(S2M_AXI_ARVALID),
        .S2M_AXI_AWADDR(S2M_AXI_AWADDR),
        .S2M_AXI_AWID(S2M_AXI_AWID),
        .S2M_AXI_AWVALID(S2M_AXI_AWVALID),
        .S2M_AXI_BREADY(S2M_AXI_BREADY),
        .S2M_AXI_RREADY(S2M_AXI_RREADY),
        .S2M_AXI_WDATA(S2M_AXI_WDATA),
        .S2M_AXI_WSTRB(S2M_AXI_WSTRB),
        .S2M_AXI_WVALID(S2M_AXI_WVALID),
        .S2M_AXI_ACLK(S2M_AXI_ACLK),
        .S2M_AXI_ARREADY(S2M_AXI_ARREADY),
        .S2M_AXI_AWREADY(S2M_AXI_AWREADY),
        .S2M_AXI_BID(S2M_AXI_BID),
        .S2M_AXI_BRESP(S2M_AXI_BRESP),
        .S2M_AXI_BVALID(S2M_AXI_BVALID),
        .S2M_AXI_RDATA(S2M_AXI_RDATA),
        .S2M_AXI_RID(S2M_AXI_RID),
        .S2M_AXI_RLAST(S2M_AXI_RLAST),
        .S2M_AXI_RRESP(S2M_AXI_RRESP),
        .S2M_AXI_RVALID(S2M_AXI_RVALID),
        .S2M_AXI_WREADY(S2M_AXI_WREADY)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial State", test_num);


            S2M_AXI_ARADDR = 32'h0;
            S2M_AXI_ARID = 12'h0;
            S2M_AXI_ARVALID = 1'b0;
            S2M_AXI_AWADDR = 32'h0;
            S2M_AXI_AWID = 12'h0;
            S2M_AXI_AWVALID = 1'b0;
            S2M_AXI_BREADY = 1'b0;
            S2M_AXI_RREADY = 1'b0;
            S2M_AXI_WDATA = 32'h0;
            S2M_AXI_WSTRB = 4'h0;
            S2M_AXI_WVALID = 1'b0;



            #1;




            check_outputs(0, 0, 0, 12'h0, 2'b00, 0, 32'h0, 12'h0, 0, 2'b00, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read Address Channel Stimulation", test_num);


            S2M_AXI_ARADDR = 32'h0; S2M_AXI_ARID = 12'h0; S2M_AXI_ARVALID = 1'b0;


            S2M_AXI_ARADDR = 32'hDEADBEEF;
            S2M_AXI_ARID = 12'hA5A;
            S2M_AXI_ARVALID = 1'b1;
            S2M_AXI_RREADY = 1'b1;

            #1;


            check_outputs(0, 0, 0, 12'h0, 2'b00, 0, 32'h0, 12'h0, 0, 2'b00, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Channel Stimulation", test_num);


            S2M_AXI_AWADDR = 32'hCAFEBABE;
            S2M_AXI_AWID = 12'h123;
            S2M_AXI_AWVALID = 1'b1;
            S2M_AXI_WDATA = 32'h87654321;
            S2M_AXI_WSTRB = 4'hF;
            S2M_AXI_WVALID = 1'b1;
            S2M_AXI_BREADY = 1'b1;

            #1;


            check_outputs(0, 0, 0, 12'h0, 2'b00, 0, 32'h0, 12'h0, 0, 2'b00, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Bus Stimulation Stress Test", test_num);

            S2M_AXI_ARVALID = 1'b1;
            S2M_AXI_AWVALID = 1'b1;
            S2M_AXI_WVALID = 1'b1;
            S2M_AXI_RREADY = 1'b1;
            S2M_AXI_BREADY = 1'b1;
            S2M_AXI_ARADDR = 32'hFFFFFFFF;
            S2M_AXI_AWADDR = 32'hFFFFFFFF;
            S2M_AXI_WDATA = 32'hFFFFFFFF;
            S2M_AXI_WSTRB = 4'hF;
            S2M_AXI_ARID = 12'hFFF;
            S2M_AXI_AWID = 12'hFFF;

            #1;


            check_outputs(0, 0, 0, 12'h0, 2'b00, 0, 32'h0, 12'h0, 0, 2'b00, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Return to Idle State", test_num);


            S2M_AXI_ARADDR = 32'h0;
            S2M_AXI_ARID = 12'h0;
            S2M_AXI_ARVALID = 1'b0;
            S2M_AXI_AWADDR = 32'h0;
            S2M_AXI_AWID = 12'h0;
            S2M_AXI_AWVALID = 1'b0;
            S2M_AXI_BREADY = 1'b0;
            S2M_AXI_RREADY = 1'b0;
            S2M_AXI_WDATA = 32'h0;
            S2M_AXI_WSTRB = 4'h0;
            S2M_AXI_WVALID = 1'b0;

            #1;


            check_outputs(0, 0, 0, 12'h0, 2'b00, 0, 32'h0, 12'h0, 0, 2'b00, 0, 0);
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
        input expected_S2M_AXI_ACLK;
        input expected_S2M_AXI_ARREADY;
        input expected_S2M_AXI_AWREADY;
        input [11:0] expected_S2M_AXI_BID;
        input [1:0] expected_S2M_AXI_BRESP;
        input expected_S2M_AXI_BVALID;
        input [31:0] expected_S2M_AXI_RDATA;
        input [11:0] expected_S2M_AXI_RID;
        input expected_S2M_AXI_RLAST;
        input [1:0] expected_S2M_AXI_RRESP;
        input expected_S2M_AXI_RVALID;
        input expected_S2M_AXI_WREADY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S2M_AXI_ACLK === (expected_S2M_AXI_ACLK ^ S2M_AXI_ACLK ^ expected_S2M_AXI_ACLK) &&
                expected_S2M_AXI_ARREADY === (expected_S2M_AXI_ARREADY ^ S2M_AXI_ARREADY ^ expected_S2M_AXI_ARREADY) &&
                expected_S2M_AXI_AWREADY === (expected_S2M_AXI_AWREADY ^ S2M_AXI_AWREADY ^ expected_S2M_AXI_AWREADY) &&
                expected_S2M_AXI_BID === (expected_S2M_AXI_BID ^ S2M_AXI_BID ^ expected_S2M_AXI_BID) &&
                expected_S2M_AXI_BRESP === (expected_S2M_AXI_BRESP ^ S2M_AXI_BRESP ^ expected_S2M_AXI_BRESP) &&
                expected_S2M_AXI_BVALID === (expected_S2M_AXI_BVALID ^ S2M_AXI_BVALID ^ expected_S2M_AXI_BVALID) &&
                expected_S2M_AXI_RDATA === (expected_S2M_AXI_RDATA ^ S2M_AXI_RDATA ^ expected_S2M_AXI_RDATA) &&
                expected_S2M_AXI_RID === (expected_S2M_AXI_RID ^ S2M_AXI_RID ^ expected_S2M_AXI_RID) &&
                expected_S2M_AXI_RLAST === (expected_S2M_AXI_RLAST ^ S2M_AXI_RLAST ^ expected_S2M_AXI_RLAST) &&
                expected_S2M_AXI_RRESP === (expected_S2M_AXI_RRESP ^ S2M_AXI_RRESP ^ expected_S2M_AXI_RRESP) &&
                expected_S2M_AXI_RVALID === (expected_S2M_AXI_RVALID ^ S2M_AXI_RVALID ^ expected_S2M_AXI_RVALID) &&
                expected_S2M_AXI_WREADY === (expected_S2M_AXI_WREADY ^ S2M_AXI_WREADY ^ expected_S2M_AXI_WREADY)) begin
                $display("PASS");
                $display("  Outputs: S2M_AXI_ACLK=%b, S2M_AXI_ARREADY=%b, S2M_AXI_AWREADY=%b, S2M_AXI_BID=%h, S2M_AXI_BRESP=%h, S2M_AXI_BVALID=%b, S2M_AXI_RDATA=%h, S2M_AXI_RID=%h, S2M_AXI_RLAST=%b, S2M_AXI_RRESP=%h, S2M_AXI_RVALID=%b, S2M_AXI_WREADY=%b",
                         S2M_AXI_ACLK, S2M_AXI_ARREADY, S2M_AXI_AWREADY, S2M_AXI_BID, S2M_AXI_BRESP, S2M_AXI_BVALID, S2M_AXI_RDATA, S2M_AXI_RID, S2M_AXI_RLAST, S2M_AXI_RRESP, S2M_AXI_RVALID, S2M_AXI_WREADY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S2M_AXI_ACLK=%b, S2M_AXI_ARREADY=%b, S2M_AXI_AWREADY=%b, S2M_AXI_BID=%h, S2M_AXI_BRESP=%h, S2M_AXI_BVALID=%b, S2M_AXI_RDATA=%h, S2M_AXI_RID=%h, S2M_AXI_RLAST=%b, S2M_AXI_RRESP=%h, S2M_AXI_RVALID=%b, S2M_AXI_WREADY=%b",
                         expected_S2M_AXI_ACLK, expected_S2M_AXI_ARREADY, expected_S2M_AXI_AWREADY, expected_S2M_AXI_BID, expected_S2M_AXI_BRESP, expected_S2M_AXI_BVALID, expected_S2M_AXI_RDATA, expected_S2M_AXI_RID, expected_S2M_AXI_RLAST, expected_S2M_AXI_RRESP, expected_S2M_AXI_RVALID, expected_S2M_AXI_WREADY);
                $display("  Got:      S2M_AXI_ACLK=%b, S2M_AXI_ARREADY=%b, S2M_AXI_AWREADY=%b, S2M_AXI_BID=%h, S2M_AXI_BRESP=%h, S2M_AXI_BVALID=%b, S2M_AXI_RDATA=%h, S2M_AXI_RID=%h, S2M_AXI_RLAST=%b, S2M_AXI_RRESP=%h, S2M_AXI_RVALID=%b, S2M_AXI_WREADY=%b",
                         S2M_AXI_ACLK, S2M_AXI_ARREADY, S2M_AXI_AWREADY, S2M_AXI_BID, S2M_AXI_BRESP, S2M_AXI_BVALID, S2M_AXI_RDATA, S2M_AXI_RID, S2M_AXI_RLAST, S2M_AXI_RRESP, S2M_AXI_RVALID, S2M_AXI_WREADY);
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
