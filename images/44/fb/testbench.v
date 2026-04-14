`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] axi_araddr;
    reg axi_arvalid;
    reg axi_rready;
    reg clk;
    reg rst;
    wire axi_arready;
    wire [31:0] axi_rdata;
    wire axi_rvalid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .axi_araddr(axi_araddr),
        .axi_arvalid(axi_arvalid),
        .axi_rready(axi_rready),
        .clk(clk),
        .rst(rst),
        .axi_arready(axi_arready),
        .axi_rdata(axi_rdata),
        .axi_rvalid(axi_rvalid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            axi_araddr = 0;
            axi_arvalid = 0;
            axi_rready = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Read Address 0x00000000");
            test_num = test_num + 1;
            reset_dut();


            axi_araddr = 32'h0000_0000;
            axi_arvalid = 1'b1;
            axi_rready = 1'b1;


            while (!axi_arready) @(posedge clk);
            @(posedge clk);
            #1;
            axi_arvalid = 1'b0;


            while (!axi_rvalid) @(posedge clk);


            #1;



            check_outputs(1'b1, 32'h0000_0000, 1'b1);


            @(posedge clk);
            #1;
            axi_rready = 1'b0;
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Read Address 0x00000200 (Index 512)");
            test_num = test_num + 1;
            reset_dut();

            axi_araddr = 32'h0000_0200;
            axi_arvalid = 1'b1;
            axi_rready = 1'b1;


            while (!axi_arready) @(posedge clk);
            @(posedge clk);
            #1;
            axi_arvalid = 1'b0;


            while (!axi_rvalid) @(posedge clk);


            #1;



            check_outputs(1'b1, 32'h0000_0000, 1'b1);

            @(posedge clk);
            #1;
            axi_rready = 1'b0;
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Read Address 0x000003FF (Index 1023)");
            test_num = test_num + 1;
            reset_dut();

            axi_araddr = 32'h0000_03FF;
            axi_arvalid = 1'b1;
            axi_rready = 1'b1;


            while (!axi_arready) @(posedge clk);
            @(posedge clk);
            #1;
            axi_arvalid = 1'b0;

            while (!axi_rvalid) @(posedge clk);


            #1;



            check_outputs(1'b1, 32'h0000_0000, 1'b1);

            @(posedge clk);
            #1;
            axi_rready = 1'b0;
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Check continuous readiness (arready)");
            test_num = test_num + 1;
            reset_dut();



            #1;




            check_outputs(1'b1, 32'h0000_0000, 1'b0);
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
        input expected_axi_arready;
        input [31:0] expected_axi_rdata;
        input expected_axi_rvalid;
        begin
            if (expected_axi_arready === (expected_axi_arready ^ axi_arready ^ expected_axi_arready) &&
                expected_axi_rdata === (expected_axi_rdata ^ axi_rdata ^ expected_axi_rdata) &&
                expected_axi_rvalid === (expected_axi_rvalid ^ axi_rvalid ^ expected_axi_rvalid)) begin
                $display("PASS");
                $display("  Outputs: axi_arready=%b, axi_rdata=%h, axi_rvalid=%b",
                         axi_arready, axi_rdata, axi_rvalid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: axi_arready=%b, axi_rdata=%h, axi_rvalid=%b",
                         expected_axi_arready, expected_axi_rdata, expected_axi_rvalid);
                $display("  Got:      axi_arready=%b, axi_rdata=%h, axi_rvalid=%b",
                         axi_arready, axi_rdata, axi_rvalid);
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
        $dumpvars(0,axi_araddr, axi_arvalid, axi_rready, clk, rst, axi_arready, axi_rdata, axi_rvalid);
    end

endmodule
