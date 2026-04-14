`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] mem_addr;
    reg mem_axi_arready;
    reg mem_axi_awready;
    reg mem_axi_bvalid;
    reg [31:0] mem_axi_rdata;
    reg mem_axi_rvalid;
    reg mem_axi_wready;
    reg mem_instr;
    reg mem_valid;
    reg [31:0] mem_wdata;
    reg [3:0] mem_wstrb;
    reg resetn;
    wire [31:0] mem_axi_araddr;
    wire [2:0] mem_axi_arprot;
    wire mem_axi_arvalid;
    wire [31:0] mem_axi_awaddr;
    wire [2:0] mem_axi_awprot;
    wire mem_axi_awvalid;
    wire mem_axi_bready;
    wire mem_axi_rready;
    wire [31:0] mem_axi_wdata;
    wire [3:0] mem_axi_wstrb;
    wire mem_axi_wvalid;
    wire [31:0] mem_rdata;
    wire mem_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_addr(mem_addr),
        .mem_axi_arready(mem_axi_arready),
        .mem_axi_awready(mem_axi_awready),
        .mem_axi_bvalid(mem_axi_bvalid),
        .mem_axi_rdata(mem_axi_rdata),
        .mem_axi_rvalid(mem_axi_rvalid),
        .mem_axi_wready(mem_axi_wready),
        .mem_instr(mem_instr),
        .mem_valid(mem_valid),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .resetn(resetn),
        .mem_axi_araddr(mem_axi_araddr),
        .mem_axi_arprot(mem_axi_arprot),
        .mem_axi_arvalid(mem_axi_arvalid),
        .mem_axi_awaddr(mem_axi_awaddr),
        .mem_axi_awprot(mem_axi_awprot),
        .mem_axi_awvalid(mem_axi_awvalid),
        .mem_axi_bready(mem_axi_bready),
        .mem_axi_rready(mem_axi_rready),
        .mem_axi_wdata(mem_axi_wdata),
        .mem_axi_wstrb(mem_axi_wstrb),
        .mem_axi_wvalid(mem_axi_wvalid),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            mem_valid = 0;
            mem_instr = 0;
            mem_addr = 0;
            mem_wdata = 0;
            mem_wstrb = 0;
            mem_axi_arready = 0;
            mem_axi_awready = 0;
            mem_axi_wready = 0;
            mem_axi_bvalid = 0;
            mem_axi_rvalid = 0;
            mem_axi_rdata = 0;
            repeat(5) @(posedge clk);
            resetn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Instruction Read");
            reset_dut();


            mem_valid = 1;
            mem_instr = 1;
            mem_addr = 32'h0000_1000;
            mem_wstrb = 4'h0;


            wait(mem_axi_arvalid);
            @(posedge clk); #1;
            mem_axi_arready = 1;
            @(posedge clk); #1;
            mem_axi_arready = 0;


            mem_axi_rdata = 32'hAABBCCDD;
            mem_axi_rvalid = 1;

            wait(mem_ready);
            @(posedge clk); #1;


            #1;



            check_outputs(
                32'h0000_1000,
                3'b100,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                32'hAABBCCDD,
                0
            );

            mem_axi_rvalid = 0;
            mem_valid = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Data Write");
            reset_dut();


            mem_valid = 1;
            mem_instr = 0;
            mem_addr = 32'h0000_2000;
            mem_wdata = 32'h1234_5678;
            mem_wstrb = 4'hF;


            wait(mem_axi_awvalid && mem_axi_wvalid);
            @(posedge clk); #1;
            mem_axi_awready = 1;
            mem_axi_wready = 1;
            @(posedge clk); #1;
            mem_axi_awready = 0;
            mem_axi_wready = 0;


            mem_axi_bvalid = 1;
            wait(mem_ready);
            @(posedge clk); #1;

            #1;


            check_outputs(
                0,
                0,
                0,
                32'h0000_2000,
                3'b000,
                0,
                0,
                0,
                32'h1234_5678,
                4'hF,
                0,
                mem_rdata,
                0
            );

            mem_axi_bvalid = 0;
            mem_valid = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Read Data with Slave Stall");
            reset_dut();

            mem_valid = 1;
            mem_instr = 0;
            mem_addr = 32'h0000_3000;
            mem_wstrb = 4'h0;


            repeat(3) @(posedge clk);
            #1 mem_axi_arready = 1;
            @(posedge clk);
            #1 mem_axi_arready = 0;


            repeat(3) @(posedge clk);
            #1 mem_axi_rdata = 32'h55AA55AA;
            mem_axi_rvalid = 1;

            wait(mem_ready);
            @(posedge clk); #1;

            #1;


            check_outputs(
                32'h0000_3000, 3'b000, 0,
                0, 0, 0, 0, 0, 0, 0, 0,
                32'h55AA55AA, 0
            );

            mem_axi_rvalid = 0;
            mem_valid = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write Data with Partial Strobe");
            reset_dut();

            mem_valid = 1;
            mem_instr = 0;
            mem_addr = 32'h0000_4000;
            mem_wdata = 32'h0000_FF00;
            mem_wstrb = 4'h2;

            wait(mem_axi_awvalid && mem_axi_wvalid);
            @(posedge clk); #1;
            mem_axi_awready = 1;
            mem_axi_wready = 1;
            @(posedge clk); #1;
            mem_axi_awready = 0;
            mem_axi_wready = 0;

            mem_axi_bvalid = 1;
            wait(mem_ready);
            @(posedge clk); #1;

            #1;


            check_outputs(
                0, 0, 0,
                32'h0000_4000, 3'b000, 0,
                0, 0, 32'h0000_FF00, 4'h2, 0,
                mem_rdata, 0
            );

            mem_axi_bvalid = 0;
            mem_valid = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Back-to-Back Operations");
            reset_dut();


            mem_valid = 1;
            mem_addr = 32'h5000;
            mem_wdata = 32'hDEADBEEF;
            mem_wstrb = 4'hF;
            wait(mem_axi_awvalid); @(posedge clk); #1;
            mem_axi_awready = 1; mem_axi_wready = 1; @(posedge clk); #1;
            mem_axi_awready = 0; mem_axi_wready = 0;
            mem_axi_bvalid = 1;
            wait(mem_ready); @(posedge clk); #1;
            mem_axi_bvalid = 0;
            mem_valid = 0;


            mem_valid = 1;
            mem_addr = 32'h5000;
            mem_wstrb = 4'h0;
            wait(mem_axi_arvalid); @(posedge clk); #1;
            mem_axi_arready = 1; @(posedge clk); #1;
            mem_axi_arready = 0;
            mem_axi_rdata = 32'hDEADBEEF;
            mem_axi_rvalid = 1;
            wait(mem_ready); @(posedge clk); #1;

            #1;


            check_outputs(
                32'h5000, 3'b000, 0,
                0, 0, 0, 0, 0, 0, 0, 0,
                32'hDEADBEEF, 0
            );
            mem_axi_rvalid = 0;
            mem_valid = 0;
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
        input [31:0] expected_mem_axi_araddr;
        input [2:0] expected_mem_axi_arprot;
        input expected_mem_axi_arvalid;
        input [31:0] expected_mem_axi_awaddr;
        input [2:0] expected_mem_axi_awprot;
        input expected_mem_axi_awvalid;
        input expected_mem_axi_bready;
        input expected_mem_axi_rready;
        input [31:0] expected_mem_axi_wdata;
        input [3:0] expected_mem_axi_wstrb;
        input expected_mem_axi_wvalid;
        input [31:0] expected_mem_rdata;
        input expected_mem_ready;
        begin
            if (expected_mem_axi_araddr === (expected_mem_axi_araddr ^ mem_axi_araddr ^ expected_mem_axi_araddr) &&
                expected_mem_axi_arprot === (expected_mem_axi_arprot ^ mem_axi_arprot ^ expected_mem_axi_arprot) &&
                expected_mem_axi_arvalid === (expected_mem_axi_arvalid ^ mem_axi_arvalid ^ expected_mem_axi_arvalid) &&
                expected_mem_axi_awaddr === (expected_mem_axi_awaddr ^ mem_axi_awaddr ^ expected_mem_axi_awaddr) &&
                expected_mem_axi_awprot === (expected_mem_axi_awprot ^ mem_axi_awprot ^ expected_mem_axi_awprot) &&
                expected_mem_axi_awvalid === (expected_mem_axi_awvalid ^ mem_axi_awvalid ^ expected_mem_axi_awvalid) &&
                expected_mem_axi_bready === (expected_mem_axi_bready ^ mem_axi_bready ^ expected_mem_axi_bready) &&
                expected_mem_axi_rready === (expected_mem_axi_rready ^ mem_axi_rready ^ expected_mem_axi_rready) &&
                expected_mem_axi_wdata === (expected_mem_axi_wdata ^ mem_axi_wdata ^ expected_mem_axi_wdata) &&
                expected_mem_axi_wstrb === (expected_mem_axi_wstrb ^ mem_axi_wstrb ^ expected_mem_axi_wstrb) &&
                expected_mem_axi_wvalid === (expected_mem_axi_wvalid ^ mem_axi_wvalid ^ expected_mem_axi_wvalid) &&
                expected_mem_rdata === (expected_mem_rdata ^ mem_rdata ^ expected_mem_rdata) &&
                expected_mem_ready === (expected_mem_ready ^ mem_ready ^ expected_mem_ready)) begin
                $display("PASS");
                $display("  Outputs: mem_axi_araddr=%h, mem_axi_arprot=%h, mem_axi_arvalid=%b, mem_axi_awaddr=%h, mem_axi_awprot=%h, mem_axi_awvalid=%b, mem_axi_bready=%b, mem_axi_rready=%b, mem_axi_wdata=%h, mem_axi_wstrb=%h, mem_axi_wvalid=%b, mem_rdata=%h, mem_ready=%b",
                         mem_axi_araddr, mem_axi_arprot, mem_axi_arvalid, mem_axi_awaddr, mem_axi_awprot, mem_axi_awvalid, mem_axi_bready, mem_axi_rready, mem_axi_wdata, mem_axi_wstrb, mem_axi_wvalid, mem_rdata, mem_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_axi_araddr=%h, mem_axi_arprot=%h, mem_axi_arvalid=%b, mem_axi_awaddr=%h, mem_axi_awprot=%h, mem_axi_awvalid=%b, mem_axi_bready=%b, mem_axi_rready=%b, mem_axi_wdata=%h, mem_axi_wstrb=%h, mem_axi_wvalid=%b, mem_rdata=%h, mem_ready=%b",
                         expected_mem_axi_araddr, expected_mem_axi_arprot, expected_mem_axi_arvalid, expected_mem_axi_awaddr, expected_mem_axi_awprot, expected_mem_axi_awvalid, expected_mem_axi_bready, expected_mem_axi_rready, expected_mem_axi_wdata, expected_mem_axi_wstrb, expected_mem_axi_wvalid, expected_mem_rdata, expected_mem_ready);
                $display("  Got:      mem_axi_araddr=%h, mem_axi_arprot=%h, mem_axi_arvalid=%b, mem_axi_awaddr=%h, mem_axi_awprot=%h, mem_axi_awvalid=%b, mem_axi_bready=%b, mem_axi_rready=%b, mem_axi_wdata=%h, mem_axi_wstrb=%h, mem_axi_wvalid=%b, mem_rdata=%h, mem_ready=%b",
                         mem_axi_araddr, mem_axi_arprot, mem_axi_arvalid, mem_axi_awaddr, mem_axi_awprot, mem_axi_awvalid, mem_axi_bready, mem_axi_rready, mem_axi_wdata, mem_axi_wstrb, mem_axi_wvalid, mem_rdata, mem_ready);
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
        $dumpvars(0,clk, mem_addr, mem_axi_arready, mem_axi_awready, mem_axi_bvalid, mem_axi_rdata, mem_axi_rvalid, mem_axi_wready, mem_instr, mem_valid, mem_wdata, mem_wstrb, resetn, mem_axi_araddr, mem_axi_arprot, mem_axi_arvalid, mem_axi_awaddr, mem_axi_awprot, mem_axi_awvalid, mem_axi_bready, mem_axi_rready, mem_axi_wdata, mem_axi_wstrb, mem_axi_wvalid, mem_rdata, mem_ready);
    end

endmodule
