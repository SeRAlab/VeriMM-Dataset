`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg s_axi_aclk;
    reg [8:0] s_axi_araddr;
    reg s_axi_aresetn;
    reg s_axi_arvalid;
    reg [8:0] s_axi_awaddr;
    reg s_axi_awvalid;
    reg s_axi_bready;
    reg s_axi_rready;
    reg [31:0] s_axi_wdata;
    reg [3:0] s_axi_wstrb;
    reg s_axi_wvalid;
    wire ip2intc_irpt;
    wire s_axi_arready;
    wire s_axi_awready;
    wire [1:0] s_axi_bresp;
    wire s_axi_bvalid;
    wire [31:0] s_axi_rdata;
    wire [1:0] s_axi_rresp;
    wire s_axi_rvalid;
    wire s_axi_wready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_rready(s_axi_rready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .ip2intc_irpt(ip2intc_irpt),
        .s_axi_arready(s_axi_arready),
        .s_axi_awready(s_axi_awready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wready(s_axi_wready)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

        begin
            s_axi_aresetn = 0;
            s_axi_awaddr = 0;
            s_axi_awvalid = 0;
            s_axi_wdata = 0;
            s_axi_wstrb = 0;
            s_axi_wvalid = 0;
            s_axi_bready = 0;
            s_axi_araddr = 0;
            s_axi_arvalid = 0;
            s_axi_rready = 0;
            repeat(5) @(posedge s_axi_aclk);
            s_axi_aresetn = 1;
            repeat(2) @(posedge s_axi_aclk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset and Initial State Check");
            reset_dut();

            #1;


            check_outputs(
                1'b0,
                s_axi_arready,
                s_axi_awready,
                2'b00,
                1'b0,
                32'h0,
                2'b00,
                1'b0,
                s_axi_wready
            );
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Write to GPIO Data Register (Addr 0x0)");
            reset_dut();
            @(posedge s_axi_aclk);

            s_axi_awaddr = 9'h000;
            s_axi_awvalid = 1;
            s_axi_wdata = 32'h000ABCDE;
            s_axi_wstrb = 4'hF;
            s_axi_wvalid = 1;
            wait(s_axi_awready && s_axi_wready);
            @(posedge s_axi_aclk);
            s_axi_awvalid = 0;
            s_axi_wvalid = 0;
            s_axi_bready = 1;
            wait(s_axi_bvalid);
            @(posedge s_axi_aclk);


            #1;



            check_outputs(0, s_axi_arready, s_axi_awready, 2'b00, 1, 32'h0, 2'b00, 0, s_axi_wready);
            s_axi_bready = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Read from GPIO Data Register (Addr 0x0)");
            reset_dut();
            @(posedge s_axi_aclk);

            s_axi_araddr = 9'h000;
            s_axi_arvalid = 1;
            wait(s_axi_arready);
            @(posedge s_axi_aclk);
            s_axi_arvalid = 0;
            s_axi_rready = 1;
            wait(s_axi_rvalid);
            @(posedge s_axi_aclk);


            #1;



            check_outputs(0, s_axi_arready, s_axi_awready, 2'b00, 0, s_axi_rdata, 2'b00, 1, s_axi_wready);
            s_axi_rready = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Write to GPIO Tri-state Register (Addr 0x4)");
            reset_dut();
            @(posedge s_axi_aclk);
            s_axi_awaddr = 9'h004;
            s_axi_awvalid = 1;
            s_axi_wdata = 32'h000FFFFF;
            s_axi_wstrb = 4'hF;
            s_axi_wvalid = 1;
            wait(s_axi_awready && s_axi_wready);
            @(posedge s_axi_aclk);
            s_axi_awvalid = 0;
            s_axi_wvalid = 0;
            s_axi_bready = 1;
            wait(s_axi_bvalid);
            @(posedge s_axi_aclk);


            #1;



            check_outputs(0, s_axi_arready, s_axi_awready, 2'b00, 1, 32'h0, 2'b00, 0, s_axi_wready);
            s_axi_bready = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Read back from Tri-state Register");
            reset_dut();
            @(posedge s_axi_aclk);

            s_axi_awaddr = 9'h004;
            s_axi_awvalid = 1;
            s_axi_wdata = 32'h55555;
            s_axi_wstrb = 4'hF;
            s_axi_wvalid = 1;
            s_axi_bready = 1;
            wait(s_axi_bvalid);
            @(posedge s_axi_aclk);
            s_axi_awvalid = 0; s_axi_wvalid = 0; s_axi_bready = 0;


            s_axi_araddr = 9'h004;
            s_axi_arvalid = 1;
            wait(s_axi_arready);
            @(posedge s_axi_aclk);
            s_axi_arvalid = 0;
            s_axi_rready = 1;
            wait(s_axi_rvalid);
            @(posedge s_axi_aclk);


            #1;



            check_outputs(0, s_axi_arready, s_axi_awready, 2'b00, 0, s_axi_rdata, 2'b00, 1, s_axi_wready);
            s_axi_rready = 0;
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
        input expected_ip2intc_irpt;
        input expected_s_axi_arready;
        input expected_s_axi_awready;
        input [1:0] expected_s_axi_bresp;
        input expected_s_axi_bvalid;
        input [31:0] expected_s_axi_rdata;
        input [1:0] expected_s_axi_rresp;
        input expected_s_axi_rvalid;
        input expected_s_axi_wready;
        begin
            if (expected_ip2intc_irpt === (expected_ip2intc_irpt ^ ip2intc_irpt ^ expected_ip2intc_irpt) &&
                expected_s_axi_arready === (expected_s_axi_arready ^ s_axi_arready ^ expected_s_axi_arready) &&
                expected_s_axi_awready === (expected_s_axi_awready ^ s_axi_awready ^ expected_s_axi_awready) &&
                expected_s_axi_bresp === (expected_s_axi_bresp ^ s_axi_bresp ^ expected_s_axi_bresp) &&
                expected_s_axi_bvalid === (expected_s_axi_bvalid ^ s_axi_bvalid ^ expected_s_axi_bvalid) &&
                expected_s_axi_rdata === (expected_s_axi_rdata ^ s_axi_rdata ^ expected_s_axi_rdata) &&
                expected_s_axi_rresp === (expected_s_axi_rresp ^ s_axi_rresp ^ expected_s_axi_rresp) &&
                expected_s_axi_rvalid === (expected_s_axi_rvalid ^ s_axi_rvalid ^ expected_s_axi_rvalid) &&
                expected_s_axi_wready === (expected_s_axi_wready ^ s_axi_wready ^ expected_s_axi_wready)) begin
                $display("PASS");
                $display("  Outputs: ip2intc_irpt=%b, s_axi_arready=%b, s_axi_awready=%b, s_axi_bresp=%h, s_axi_bvalid=%b, s_axi_rdata=%h, s_axi_rresp=%h, s_axi_rvalid=%b, s_axi_wready=%b",
                         ip2intc_irpt, s_axi_arready, s_axi_awready, s_axi_bresp, s_axi_bvalid, s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_wready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ip2intc_irpt=%b, s_axi_arready=%b, s_axi_awready=%b, s_axi_bresp=%h, s_axi_bvalid=%b, s_axi_rdata=%h, s_axi_rresp=%h, s_axi_rvalid=%b, s_axi_wready=%b",
                         expected_ip2intc_irpt, expected_s_axi_arready, expected_s_axi_awready, expected_s_axi_bresp, expected_s_axi_bvalid, expected_s_axi_rdata, expected_s_axi_rresp, expected_s_axi_rvalid, expected_s_axi_wready);
                $display("  Got:      ip2intc_irpt=%b, s_axi_arready=%b, s_axi_awready=%b, s_axi_bresp=%h, s_axi_bvalid=%b, s_axi_rdata=%h, s_axi_rresp=%h, s_axi_rvalid=%b, s_axi_wready=%b",
                         ip2intc_irpt, s_axi_arready, s_axi_awready, s_axi_bresp, s_axi_bvalid, s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_wready);
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
        $dumpvars(0,s_axi_aclk, s_axi_araddr, s_axi_aresetn, s_axi_arvalid, s_axi_awaddr, s_axi_awvalid, s_axi_bready, s_axi_rready, s_axi_wdata, s_axi_wstrb, s_axi_wvalid, ip2intc_irpt, s_axi_arready, s_axi_awready, s_axi_bresp, s_axi_bvalid, s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_wready);
    end

endmodule
