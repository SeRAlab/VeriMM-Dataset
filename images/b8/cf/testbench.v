`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg s_axi_aclk;
    reg [2:0] s_axi_araddr;
    reg s_axi_aresetn;
    reg s_axi_arvalid;
    reg [2:0] s_axi_awaddr;
    reg s_axi_awvalid;
    reg s_axi_bready;
    reg s_axi_rready;
    reg [11:0] s_axi_wdata;
    reg s_axi_wvalid;
    wire [3:0] gpio_io_t;
    wire [11:0] s_axi_rdata;
    wire s_axi_rvalid;

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
        .s_axi_wvalid(s_axi_wvalid),
        .gpio_io_t(gpio_io_t),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rvalid(s_axi_rvalid)
    );

    // Clock generation (10ns period)
    initial begin
        s_axi_aclk = 0;
        forever #5 s_axi_aclk = ~s_axi_aclk;
    end

        task reset_dut;

    begin
        s_axi_aresetn = 0;
        s_axi_arvalid = 0;
        s_axi_araddr = 3'b0;
        s_axi_rready = 0;
        s_axi_awvalid = 0;
        s_axi_awaddr = 3'b0;
        s_axi_wvalid = 0;
        s_axi_wdata = 12'b0;
        s_axi_bready = 0;
        repeat(2) @(posedge s_axi_aclk);
        s_axi_aresetn = 1;
        @(posedge s_axi_aclk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        s_axi_awaddr = 3'h0;
        s_axi_awvalid = 1;
        s_axi_wdata = 12'hA5A;
        s_axi_wvalid = 1;
        s_axi_bready = 1;
        @(posedge s_axi_aclk);
        s_axi_awvalid = 0;
        s_axi_wvalid = 0;
        s_axi_bready = 0;


        s_axi_araddr = 3'h0;
        s_axi_arvalid = 1;
        s_axi_rready = 1;
        @(posedge s_axi_aclk);
        s_axi_arvalid = 0;


        #1;



        check_outputs(4'hA, 12'hA5A, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        #1;


        check_outputs(4'h0, 12'h000, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        s_axi_awaddr = 3'h7;
        s_axi_awvalid = 1;
        s_axi_wdata = 12'hF0F;
        s_axi_wvalid = 1;
        s_axi_bready = 1;
        @(posedge s_axi_aclk);
        s_axi_awvalid = 0;
        s_axi_wvalid = 0;


        s_axi_araddr = 3'h7;
        s_axi_arvalid = 1;
        s_axi_rready = 1;
        @(posedge s_axi_aclk);
        s_axi_arvalid = 0;


        #1;



        check_outputs(4'hF, 12'hF0F, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        s_axi_awaddr = 3'h1;
        s_axi_awvalid = 1;
        s_axi_wdata = 12'h123;
        s_axi_wvalid = 1;
        @(posedge s_axi_aclk);


        s_axi_awaddr = 3'h2;
        s_axi_wdata = 12'h456;
        @(posedge s_axi_aclk);
        s_axi_awvalid = 0;
        s_axi_wvalid = 0;


        s_axi_araddr = 3'h1;
        s_axi_arvalid = 1;
        s_axi_rready = 1;
        @(posedge s_axi_aclk);
        s_axi_arvalid = 0;


        #1;



        check_outputs(4'h6, 12'h123, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        s_axi_awaddr = 3'h4;
        s_axi_awvalid = 1;
        s_axi_wdata = 12'hAAA;
        s_axi_wvalid = 1;
        @(posedge s_axi_aclk);


        s_axi_wdata = 12'h555;
        @(posedge s_axi_aclk);
        s_axi_awvalid = 0;
        s_axi_wvalid = 0;


        s_axi_araddr = 3'h4;
        s_axi_arvalid = 1;
        s_axi_rready = 1;
        @(posedge s_axi_aclk);
        s_axi_arvalid = 0;


        #1;



        check_outputs(4'h5, 12'h555, 1'b1);
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
        input [3:0] expected_gpio_io_t;
        input [11:0] expected_s_axi_rdata;
        input expected_s_axi_rvalid;
        begin
            if (expected_gpio_io_t === (expected_gpio_io_t ^ gpio_io_t ^ expected_gpio_io_t) &&
                expected_s_axi_rdata === (expected_s_axi_rdata ^ s_axi_rdata ^ expected_s_axi_rdata) &&
                expected_s_axi_rvalid === (expected_s_axi_rvalid ^ s_axi_rvalid ^ expected_s_axi_rvalid)) begin
                $display("PASS");
                $display("  Outputs: gpio_io_t=%h, s_axi_rdata=%h, s_axi_rvalid=%b",
                         gpio_io_t, s_axi_rdata, s_axi_rvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio_io_t=%h, s_axi_rdata=%h, s_axi_rvalid=%b",
                         expected_gpio_io_t, expected_s_axi_rdata, expected_s_axi_rvalid);
                $display("  Got:      gpio_io_t=%h, s_axi_rdata=%h, s_axi_rvalid=%b",
                         gpio_io_t, s_axi_rdata, s_axi_rvalid);
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
        $dumpvars(0,s_axi_aclk, s_axi_araddr, s_axi_aresetn, s_axi_arvalid, s_axi_awaddr, s_axi_awvalid, s_axi_bready, s_axi_rready, s_axi_wdata, s_axi_wvalid, gpio_io_t, s_axi_rdata, s_axi_rvalid);
    end

endmodule
