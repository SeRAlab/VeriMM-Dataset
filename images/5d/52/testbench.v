`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] bram_rddata_a;
    reg s_axi_aclk;
    reg [15:0] s_axi_araddr;
    reg s_axi_aresetn;
    reg [2:0] s_axi_arprot;
    reg s_axi_arvalid;
    reg [15:0] s_axi_awaddr;
    reg [2:0] s_axi_awprot;
    reg s_axi_awvalid;
    reg s_axi_bready;
    reg s_axi_rready;
    reg [31:0] s_axi_wdata;
    reg [3:0] s_axi_wstrb;
    reg s_axi_wvalid;
    wire [15:0] bram_addr_a;
    wire bram_clk_a;
    wire bram_en_a;
    wire bram_rst_a;
    wire [3:0] bram_we_a;
    wire [31:0] bram_wrdata_a;
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
        .bram_rddata_a(bram_rddata_a),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_rready(s_axi_rready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .bram_addr_a(bram_addr_a),
        .bram_clk_a(bram_clk_a),
        .bram_en_a(bram_en_a),
        .bram_rst_a(bram_rst_a),
        .bram_we_a(bram_we_a),
        .bram_wrdata_a(bram_wrdata_a),
        .s_axi_arready(s_axi_arready),
        .s_axi_awready(s_axi_awready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wready(s_axi_wready)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase%03d: System Reset State", test_num);
        reset_dut();


        @(negedge s_axi_aclk);




        #1;





        check_outputs(16'h0000, 1'b0, 1'b0, 1'b0, 4'h0, 32'h0, 1'b1, 1'b1, 2'b00, 1'b0, 32'h0, 2'b00, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase%03d: Simple Write Transaction", test_num);
        reset_dut();


        @(posedge s_axi_aclk);
        s_axi_awaddr = 16'h1000;
        s_axi_awvalid = 1;
        s_axi_wdata = 32'hDEADBEEF;
        s_axi_wstrb = 4'hF;
        s_axi_wvalid = 1;


        wait(s_axi_awready && s_axi_wready);
        @(posedge s_axi_aclk);
        s_axi_awvalid = 0;
        s_axi_wvalid = 0;


        s_axi_bready = 1;
        wait(s_axi_bvalid);
        @(posedge s_axi_aclk);
        s_axi_bready = 0;


        @(negedge s_axi_aclk);
        #1;

        check_outputs(16'h1000, 1'b0, 1'b0, 1'b0, 4'h0, 32'hDEADBEEF, 1'b1, 1'b1, 2'b00, 1'b0, 32'h0, 2'b00, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase%03d: Simple Read Transaction", test_num);
        reset_dut();


        @(posedge s_axi_aclk);
        s_axi_araddr = 16'h2000;
        s_axi_arvalid = 1;


        wait(s_axi_arready);
        @(posedge s_axi_aclk);
        s_axi_arvalid = 0;


        s_axi_rready = 1;
        bram_rddata_a = 32'hCAFEBABE;


        wait(s_axi_rvalid);
        @(posedge s_axi_aclk);
        s_axi_rready = 0;


        @(negedge s_axi_aclk);
        #1;

        check_outputs(16'h2000, 1'b0, 1'b0, 1'b0, 4'h0, 32'h0, 1'b1, 1'b1, 2'b00, 1'b0, 32'hCAFEBABE, 2'b00, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase%03d: Write with Byte Strobe", test_num);
        reset_dut();


        @(posedge s_axi_aclk);
        s_axi_awaddr = 16'h0004;
        s_axi_awvalid = 1;
        s_axi_wdata = 32'hAABBCCDD;
        s_axi_wstrb = 4'b0110;
        s_axi_wvalid = 1;

        wait(s_axi_awready && s_axi_wready);
        @(posedge s_axi_aclk);
        s_axi_awvalid = 0;
        s_axi_wvalid = 0;
        s_axi_bready = 1;
        wait(s_axi_bvalid);
        @(posedge s_axi_aclk);
        s_axi_bready = 0;


        @(negedge s_axi_aclk);


        #1;



        check_outputs(16'h0004, 1'b0, 1'b0, 1'b0, 4'h0, 32'hAABBCCDD, 1'b1, 1'b1, 2'b00, 1'b0, 32'h0, 2'b00, 1'b0, 1'b1);
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
        input [15:0] expected_bram_addr_a;
        input expected_bram_clk_a;
        input expected_bram_en_a;
        input expected_bram_rst_a;
        input [3:0] expected_bram_we_a;
        input [31:0] expected_bram_wrdata_a;
        input expected_s_axi_arready;
        input expected_s_axi_awready;
        input [1:0] expected_s_axi_bresp;
        input expected_s_axi_bvalid;
        input [31:0] expected_s_axi_rdata;
        input [1:0] expected_s_axi_rresp;
        input expected_s_axi_rvalid;
        input expected_s_axi_wready;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bram_addr_a === (expected_bram_addr_a ^ bram_addr_a ^ expected_bram_addr_a) &&
                expected_bram_clk_a === (expected_bram_clk_a ^ bram_clk_a ^ expected_bram_clk_a) &&
                expected_bram_en_a === (expected_bram_en_a ^ bram_en_a ^ expected_bram_en_a) &&
                expected_bram_rst_a === (expected_bram_rst_a ^ bram_rst_a ^ expected_bram_rst_a) &&
                expected_bram_we_a === (expected_bram_we_a ^ bram_we_a ^ expected_bram_we_a) &&
                expected_bram_wrdata_a === (expected_bram_wrdata_a ^ bram_wrdata_a ^ expected_bram_wrdata_a) &&
                expected_s_axi_arready === (expected_s_axi_arready ^ s_axi_arready ^ expected_s_axi_arready) &&
                expected_s_axi_awready === (expected_s_axi_awready ^ s_axi_awready ^ expected_s_axi_awready) &&
                expected_s_axi_bresp === (expected_s_axi_bresp ^ s_axi_bresp ^ expected_s_axi_bresp) &&
                expected_s_axi_bvalid === (expected_s_axi_bvalid ^ s_axi_bvalid ^ expected_s_axi_bvalid) &&
                expected_s_axi_rdata === (expected_s_axi_rdata ^ s_axi_rdata ^ expected_s_axi_rdata) &&
                expected_s_axi_rresp === (expected_s_axi_rresp ^ s_axi_rresp ^ expected_s_axi_rresp) &&
                expected_s_axi_rvalid === (expected_s_axi_rvalid ^ s_axi_rvalid ^ expected_s_axi_rvalid) &&
                expected_s_axi_wready === (expected_s_axi_wready ^ s_axi_wready ^ expected_s_axi_wready)) begin
                $display("PASS");
                $display("  Outputs: bram_addr_a=%h, bram_clk_a=%b, bram_en_a=%b, bram_rst_a=%b, bram_we_a=%h, bram_wrdata_a=%h, s_axi_arready=%b, s_axi_awready=%b, s_axi_bresp=%h, s_axi_bvalid=%b, s_axi_rdata=%h, s_axi_rresp=%h, s_axi_rvalid=%b, s_axi_wready=%b",
                         bram_addr_a, bram_clk_a, bram_en_a, bram_rst_a, bram_we_a, bram_wrdata_a, s_axi_arready, s_axi_awready, s_axi_bresp, s_axi_bvalid, s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_wready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bram_addr_a=%h, bram_clk_a=%b, bram_en_a=%b, bram_rst_a=%b, bram_we_a=%h, bram_wrdata_a=%h, s_axi_arready=%b, s_axi_awready=%b, s_axi_bresp=%h, s_axi_bvalid=%b, s_axi_rdata=%h, s_axi_rresp=%h, s_axi_rvalid=%b, s_axi_wready=%b",
                         expected_bram_addr_a, expected_bram_clk_a, expected_bram_en_a, expected_bram_rst_a, expected_bram_we_a, expected_bram_wrdata_a, expected_s_axi_arready, expected_s_axi_awready, expected_s_axi_bresp, expected_s_axi_bvalid, expected_s_axi_rdata, expected_s_axi_rresp, expected_s_axi_rvalid, expected_s_axi_wready);
                $display("  Got:      bram_addr_a=%h, bram_clk_a=%b, bram_en_a=%b, bram_rst_a=%b, bram_we_a=%h, bram_wrdata_a=%h, s_axi_arready=%b, s_axi_awready=%b, s_axi_bresp=%h, s_axi_bvalid=%b, s_axi_rdata=%h, s_axi_rresp=%h, s_axi_rvalid=%b, s_axi_wready=%b",
                         bram_addr_a, bram_clk_a, bram_en_a, bram_rst_a, bram_we_a, bram_wrdata_a, s_axi_arready, s_axi_awready, s_axi_bresp, s_axi_bvalid, s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_wready);
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
