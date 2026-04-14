`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ACLK;
    reg ARESETN;
    reg [31:0] M_AXI_ARADDR;
    reg [3:0] M_AXI_ARCACHE;
    reg [2:0] M_AXI_ARPROT;
    reg M_AXI_ARVALID;
    reg [31:0] M_AXI_AWADDR;
    reg [3:0] M_AXI_AWCACHE;
    reg [2:0] M_AXI_AWPROT;
    reg M_AXI_AWVALID;
    reg M_AXI_BREADY;
    reg M_AXI_RREADY;
    reg [31:0] M_AXI_WDATA;
    reg [3:0] M_AXI_WSTRB;
    reg M_AXI_WVALID;
    wire M_AXI_ARREADY;
    wire M_AXI_AWREADY;
    wire [1:0] M_AXI_BRESP;
    wire M_AXI_BVALID;
    wire [31:0] M_AXI_RDATA;
    wire [1:0] M_AXI_RRESP;
    wire M_AXI_RVALID;
    wire M_AXI_WREADY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACLK(ACLK),
        .ARESETN(ARESETN),
        .M_AXI_ARADDR(M_AXI_ARADDR),
        .M_AXI_ARCACHE(M_AXI_ARCACHE),
        .M_AXI_ARPROT(M_AXI_ARPROT),
        .M_AXI_ARVALID(M_AXI_ARVALID),
        .M_AXI_AWADDR(M_AXI_AWADDR),
        .M_AXI_AWCACHE(M_AXI_AWCACHE),
        .M_AXI_AWPROT(M_AXI_AWPROT),
        .M_AXI_AWVALID(M_AXI_AWVALID),
        .M_AXI_BREADY(M_AXI_BREADY),
        .M_AXI_RREADY(M_AXI_RREADY),
        .M_AXI_WDATA(M_AXI_WDATA),
        .M_AXI_WSTRB(M_AXI_WSTRB),
        .M_AXI_WVALID(M_AXI_WVALID),
        .M_AXI_ARREADY(M_AXI_ARREADY),
        .M_AXI_AWREADY(M_AXI_AWREADY),
        .M_AXI_BRESP(M_AXI_BRESP),
        .M_AXI_BVALID(M_AXI_BVALID),
        .M_AXI_RDATA(M_AXI_RDATA),
        .M_AXI_RRESP(M_AXI_RRESP),
        .M_AXI_RVALID(M_AXI_RVALID),
        .M_AXI_WREADY(M_AXI_WREADY)
    );

    // Clock generation (10ns period)
    initial begin
        ACLK = 0;
        forever #5 ACLK = ~ACLK;
    end

        task reset_dut;

    begin
        ARESETN = 0;
        M_AXI_ARADDR = 0;
        M_AXI_ARCACHE = 0;
        M_AXI_ARPROT = 0;
        M_AXI_ARVALID = 0;
        M_AXI_AWADDR = 0;
        M_AXI_AWCACHE = 0;
        M_AXI_AWPROT = 0;
        M_AXI_AWVALID = 0;
        M_AXI_BREADY = 0;
        M_AXI_RREADY = 0;
        M_AXI_WDATA = 0;
        M_AXI_WSTRB = 0;
        M_AXI_WVALID = 0;
        repeat(2) @(posedge ACLK);
        #1 ARESETN = 1;
        repeat(2) @(posedge ACLK);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Basic Read Transaction");

        @(posedge ACLK);
        M_AXI_ARADDR = 32'hABCD1234;
        M_AXI_ARVALID = 1;
        M_AXI_RREADY = 1;


        wait(M_AXI_ARREADY);
        @(posedge ACLK);
        M_AXI_ARVALID = 0;


        wait(M_AXI_RVALID);
        @(posedge ACLK);
        #1;



        #1;




        check_outputs(M_AXI_ARREADY, M_AXI_AWREADY, 2'b00, 1'b0, 32'hABCD1234, 2'b00, 1'b1, M_AXI_WREADY);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Basic Write Transaction");

        @(posedge ACLK);
        M_AXI_AWADDR = 32'h55AA55AA;
        M_AXI_AWVALID = 1;
        M_AXI_WDATA = 32'hDEADBEEF;
        M_AXI_WVALID = 1;
        M_AXI_BREADY = 1;
        M_AXI_WSTRB = 4'hF;


        wait(M_AXI_AWREADY && M_AXI_WREADY);
        @(posedge ACLK);
        M_AXI_AWVALID = 0;
        M_AXI_WVALID = 0;


        wait(M_AXI_BVALID);
        @(posedge ACLK);
        #1;


        #1;



        check_outputs(M_AXI_ARREADY, M_AXI_AWREADY, 2'b00, 1'b1, M_AXI_RDATA, 2'b00, 1'b0, M_AXI_WREADY);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Successive Read Transaction");


        @(posedge ACLK);
        M_AXI_ARADDR = 32'h11112222;
        M_AXI_ARVALID = 1;
        M_AXI_RREADY = 1;
        wait(M_AXI_ARREADY);
        @(posedge ACLK);
        M_AXI_ARVALID = 0;
        wait(M_AXI_RVALID);
        @(posedge ACLK);


        M_AXI_ARADDR = 32'h88889999;
        M_AXI_ARVALID = 1;
        wait(M_AXI_ARREADY);
        @(posedge ACLK);
        M_AXI_ARVALID = 0;
        wait(M_AXI_RVALID);
        @(posedge ACLK);
        #1;


        #1;



        check_outputs(M_AXI_ARREADY, M_AXI_AWREADY, 2'b00, 1'b0, 32'h88889999, 2'b00, 1'b1, M_AXI_WREADY);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Reset Recovery State Check");

        #1;

        #1;


        check_outputs(M_AXI_ARREADY, M_AXI_AWREADY, 2'b00, 1'b0, 32'h0, 2'b00, 1'b0, M_AXI_WREADY);
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
        input expected_M_AXI_ARREADY;
        input expected_M_AXI_AWREADY;
        input [1:0] expected_M_AXI_BRESP;
        input expected_M_AXI_BVALID;
        input [31:0] expected_M_AXI_RDATA;
        input [1:0] expected_M_AXI_RRESP;
        input expected_M_AXI_RVALID;
        input expected_M_AXI_WREADY;
        begin
            if (expected_M_AXI_ARREADY === (expected_M_AXI_ARREADY ^ M_AXI_ARREADY ^ expected_M_AXI_ARREADY) &&
                expected_M_AXI_AWREADY === (expected_M_AXI_AWREADY ^ M_AXI_AWREADY ^ expected_M_AXI_AWREADY) &&
                expected_M_AXI_BRESP === (expected_M_AXI_BRESP ^ M_AXI_BRESP ^ expected_M_AXI_BRESP) &&
                expected_M_AXI_BVALID === (expected_M_AXI_BVALID ^ M_AXI_BVALID ^ expected_M_AXI_BVALID) &&
                expected_M_AXI_RDATA === (expected_M_AXI_RDATA ^ M_AXI_RDATA ^ expected_M_AXI_RDATA) &&
                expected_M_AXI_RRESP === (expected_M_AXI_RRESP ^ M_AXI_RRESP ^ expected_M_AXI_RRESP) &&
                expected_M_AXI_RVALID === (expected_M_AXI_RVALID ^ M_AXI_RVALID ^ expected_M_AXI_RVALID) &&
                expected_M_AXI_WREADY === (expected_M_AXI_WREADY ^ M_AXI_WREADY ^ expected_M_AXI_WREADY)) begin
                $display("PASS");
                $display("  Outputs: M_AXI_ARREADY=%b, M_AXI_AWREADY=%b, M_AXI_BRESP=%h, M_AXI_BVALID=%b, M_AXI_RDATA=%h, M_AXI_RRESP=%h, M_AXI_RVALID=%b, M_AXI_WREADY=%b",
                         M_AXI_ARREADY, M_AXI_AWREADY, M_AXI_BRESP, M_AXI_BVALID, M_AXI_RDATA, M_AXI_RRESP, M_AXI_RVALID, M_AXI_WREADY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_AXI_ARREADY=%b, M_AXI_AWREADY=%b, M_AXI_BRESP=%h, M_AXI_BVALID=%b, M_AXI_RDATA=%h, M_AXI_RRESP=%h, M_AXI_RVALID=%b, M_AXI_WREADY=%b",
                         expected_M_AXI_ARREADY, expected_M_AXI_AWREADY, expected_M_AXI_BRESP, expected_M_AXI_BVALID, expected_M_AXI_RDATA, expected_M_AXI_RRESP, expected_M_AXI_RVALID, expected_M_AXI_WREADY);
                $display("  Got:      M_AXI_ARREADY=%b, M_AXI_AWREADY=%b, M_AXI_BRESP=%h, M_AXI_BVALID=%b, M_AXI_RDATA=%h, M_AXI_RRESP=%h, M_AXI_RVALID=%b, M_AXI_WREADY=%b",
                         M_AXI_ARREADY, M_AXI_AWREADY, M_AXI_BRESP, M_AXI_BVALID, M_AXI_RDATA, M_AXI_RRESP, M_AXI_RVALID, M_AXI_WREADY);
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
        $dumpvars(0,ACLK, ARESETN, M_AXI_ARADDR, M_AXI_ARCACHE, M_AXI_ARPROT, M_AXI_ARVALID, M_AXI_AWADDR, M_AXI_AWCACHE, M_AXI_AWPROT, M_AXI_AWVALID, M_AXI_BREADY, M_AXI_RREADY, M_AXI_WDATA, M_AXI_WSTRB, M_AXI_WVALID, M_AXI_ARREADY, M_AXI_AWREADY, M_AXI_BRESP, M_AXI_BVALID, M_AXI_RDATA, M_AXI_RRESP, M_AXI_RVALID, M_AXI_WREADY);
    end

endmodule
