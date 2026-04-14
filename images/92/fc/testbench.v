`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg S_AXI_ACLK;
    reg [2:0] S_AXI_ARADDR;
    reg S_AXI_ARESETN;
    reg S_AXI_ARVALID;
    reg [2:0] S_AXI_AWADDR;
    reg S_AXI_AWVALID;
    reg S_AXI_BREADY;
    reg S_AXI_RREADY;
    reg [31:0] S_AXI_WDATA;
    reg S_AXI_WVALID;
    wire S_AXI_ARREADY;
    wire S_AXI_AWREADY;
    wire S_AXI_BVALID;
    wire [31:0] S_AXI_RDATA;
    wire S_AXI_RVALID;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S_AXI_ACLK(S_AXI_ACLK),
        .S_AXI_ARADDR(S_AXI_ARADDR),
        .S_AXI_ARESETN(S_AXI_ARESETN),
        .S_AXI_ARVALID(S_AXI_ARVALID),
        .S_AXI_AWADDR(S_AXI_AWADDR),
        .S_AXI_AWVALID(S_AXI_AWVALID),
        .S_AXI_BREADY(S_AXI_BREADY),
        .S_AXI_RREADY(S_AXI_RREADY),
        .S_AXI_WDATA(S_AXI_WDATA),
        .S_AXI_WVALID(S_AXI_WVALID),
        .S_AXI_ARREADY(S_AXI_ARREADY),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_BVALID(S_AXI_BVALID),
        .S_AXI_RDATA(S_AXI_RDATA),
        .S_AXI_RVALID(S_AXI_RVALID),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        S_AXI_ACLK = 0;
        forever #5 S_AXI_ACLK = ~S_AXI_ACLK;
    end

        task reset_dut;

        begin
            S_AXI_ARESETN = 0;
            S_AXI_AWADDR = 3'b0;
            S_AXI_AWVALID = 1'b0;
            S_AXI_WDATA = 32'h0;
            S_AXI_WVALID = 1'b0;
            S_AXI_BREADY = 1'b0;
            S_AXI_ARADDR = 3'b0;
            S_AXI_ARVALID = 1'b0;
            S_AXI_RREADY = 1'b0;
            repeat(5) @(posedge S_AXI_ACLK);
            S_AXI_ARESETN = 1;
            repeat(2) @(posedge S_AXI_ACLK);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Initial state check...");
            reset_dut();
            test_num = 1;



            #1;




            check_outputs(S_AXI_ARREADY, S_AXI_AWREADY, 1'b0, 32'h0, 1'b0, out);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Read Transaction...");
            reset_dut();
            test_num = 2;


            @(posedge S_AXI_ACLK);
            S_AXI_ARADDR = 3'h4;
            S_AXI_ARVALID = 1'b1;
            S_AXI_RREADY = 1'b1;


            wait(S_AXI_ARREADY && S_AXI_ARVALID);
            @(posedge S_AXI_ACLK);
            S_AXI_ARVALID = 1'b0;


            wait(S_AXI_RVALID);
            @(posedge S_AXI_ACLK);


            #1;



            check_outputs(S_AXI_ARREADY, S_AXI_AWREADY, 1'b0, S_AXI_RDATA, 1'b0, out);
            S_AXI_RREADY = 1'b0;
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Single Write Transaction...");
            reset_dut();
            test_num = 3;


            @(posedge S_AXI_ACLK);
            S_AXI_AWADDR = 3'h2;
            S_AXI_AWVALID = 1'b1;
            S_AXI_WDATA = 32'hDEADBEEF;
            S_AXI_WVALID = 1'b1;
            S_AXI_BREADY = 1'b1;


            wait(S_AXI_AWREADY && S_AXI_AWVALID);
            wait(S_AXI_WVALID);

            @(posedge S_AXI_ACLK);
            S_AXI_AWVALID = 1'b0;
            S_AXI_WVALID = 1'b0;


            wait(S_AXI_BVALID);
            @(posedge S_AXI_ACLK);


            #1;



            check_outputs(S_AXI_ARREADY, S_AXI_AWREADY, 1'b0, S_AXI_RDATA, 1'b0, out);
            S_AXI_BREADY = 1'b0;
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Sequential Read Transactions...");
            reset_dut();
            test_num = 4;


            @(posedge S_AXI_ACLK);
            S_AXI_ARADDR = 3'h1;
            S_AXI_ARVALID = 1'b1;
            S_AXI_RREADY = 1'b1;
            wait(S_AXI_RVALID);
            @(posedge S_AXI_ACLK);
            S_AXI_ARVALID = 1'b0;


            @(posedge S_AXI_ACLK);
            S_AXI_ARADDR = 3'h2;
            S_AXI_ARVALID = 1'b1;
            wait(S_AXI_RVALID);
            @(posedge S_AXI_ACLK);
            S_AXI_ARVALID = 1'b0;
            S_AXI_RREADY = 1'b0;


            #1;



            check_outputs(S_AXI_ARREADY, S_AXI_AWREADY, 1'b0, S_AXI_RDATA, 1'b0, out);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Simultaneous Read/Write...");
            reset_dut();
            test_num = 5;

            @(posedge S_AXI_ACLK);

            S_AXI_AWADDR = 3'h0;
            S_AXI_AWVALID = 1'b1;
            S_AXI_WDATA = 32'hAAAA5555;
            S_AXI_WVALID = 1'b1;
            S_AXI_BREADY = 1'b1;

            S_AXI_ARADDR = 3'h0;
            S_AXI_ARVALID = 1'b1;
            S_AXI_RREADY = 1'b1;


            wait(S_AXI_BVALID && S_AXI_RVALID);
            repeat(2) @(posedge S_AXI_ACLK);

            S_AXI_AWVALID = 1'b0;
            S_AXI_WVALID = 1'b0;
            S_AXI_ARVALID = 1'b0;

            #1;


            check_outputs(S_AXI_ARREADY, S_AXI_AWREADY, S_AXI_BVALID, S_AXI_RDATA, S_AXI_RVALID, out);

            S_AXI_BREADY = 1'b0;
            S_AXI_RREADY = 1'b0;
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
        input expected_S_AXI_ARREADY;
        input expected_S_AXI_AWREADY;
        input expected_S_AXI_BVALID;
        input [31:0] expected_S_AXI_RDATA;
        input expected_S_AXI_RVALID;
        input [1:0] expected_out;
        begin
            if (expected_S_AXI_ARREADY === (expected_S_AXI_ARREADY ^ S_AXI_ARREADY ^ expected_S_AXI_ARREADY) &&
                expected_S_AXI_AWREADY === (expected_S_AXI_AWREADY ^ S_AXI_AWREADY ^ expected_S_AXI_AWREADY) &&
                expected_S_AXI_BVALID === (expected_S_AXI_BVALID ^ S_AXI_BVALID ^ expected_S_AXI_BVALID) &&
                expected_S_AXI_RDATA === (expected_S_AXI_RDATA ^ S_AXI_RDATA ^ expected_S_AXI_RDATA) &&
                expected_S_AXI_RVALID === (expected_S_AXI_RVALID ^ S_AXI_RVALID ^ expected_S_AXI_RVALID) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: S_AXI_ARREADY=%b, S_AXI_AWREADY=%b, S_AXI_BVALID=%b, S_AXI_RDATA=%h, S_AXI_RVALID=%b, out=%h",
                         S_AXI_ARREADY, S_AXI_AWREADY, S_AXI_BVALID, S_AXI_RDATA, S_AXI_RVALID, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S_AXI_ARREADY=%b, S_AXI_AWREADY=%b, S_AXI_BVALID=%b, S_AXI_RDATA=%h, S_AXI_RVALID=%b, out=%h",
                         expected_S_AXI_ARREADY, expected_S_AXI_AWREADY, expected_S_AXI_BVALID, expected_S_AXI_RDATA, expected_S_AXI_RVALID, expected_out);
                $display("  Got:      S_AXI_ARREADY=%b, S_AXI_AWREADY=%b, S_AXI_BVALID=%b, S_AXI_RDATA=%h, S_AXI_RVALID=%b, out=%h",
                         S_AXI_ARREADY, S_AXI_AWREADY, S_AXI_BVALID, S_AXI_RDATA, S_AXI_RVALID, out);
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
        $dumpvars(0,S_AXI_ACLK, S_AXI_ARADDR, S_AXI_ARESETN, S_AXI_ARVALID, S_AXI_AWADDR, S_AXI_AWVALID, S_AXI_BREADY, S_AXI_RREADY, S_AXI_WDATA, S_AXI_WVALID, S_AXI_ARREADY, S_AXI_AWREADY, S_AXI_BVALID, S_AXI_RDATA, S_AXI_RVALID, out);
    end

endmodule
