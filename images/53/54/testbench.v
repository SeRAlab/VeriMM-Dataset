`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] BUS_ADDR;
    reg [31:0] BUS_WDATA;
    reg BUS_WE;
    reg CLK;
    reg RST_N;
    wire [31:0] BUS_RDATA;
    wire EXPIRED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BUS_ADDR(BUS_ADDR),
        .BUS_WDATA(BUS_WDATA),
        .BUS_WE(BUS_WE),
        .CLK(CLK),
        .RST_N(RST_N),
        .BUS_RDATA(BUS_RDATA),
        .EXPIRED(EXPIRED)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_N = 0;
            BUS_WE = 0;
            BUS_ADDR = 0;
            BUS_WDATA = 0;
            repeat(2) @(posedge CLK);
            #1 RST_N = 1;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            BUS_WE = 1;
            BUS_ADDR = 4'h0;
            BUS_WDATA = 32'd10;
            @(posedge CLK);
            BUS_WE = 0;


            repeat(10) @(posedge CLK);


            #1 #1;
 check_outputs(32'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            BUS_WE = 1;
            BUS_ADDR = 4'h0;
            BUS_WDATA = 32'hABCDEFF0;
            @(posedge CLK);
            BUS_WE = 0;


            #1 #1;
 check_outputs(32'hABCDEFF0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            BUS_WE = 1;
            BUS_ADDR = 4'h0;
            BUS_WDATA = 32'd100;
            @(posedge CLK);
            BUS_WE = 0;


            repeat(50) @(posedge CLK);


            #1 #1;
 check_outputs(32'd100, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            BUS_WE = 1;
            BUS_ADDR = 4'h0;
            BUS_WDATA = 32'd20;
            @(posedge CLK);
            BUS_WE = 0;

            repeat(5) @(posedge CLK);


            BUS_WE = 1;
            BUS_ADDR = 4'h0;
            BUS_WDATA = 32'd10;
            @(posedge CLK);
            BUS_WE = 0;


            repeat(5) @(posedge CLK);

            #1 #1;
 check_outputs(32'd10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            BUS_WE = 1;
            BUS_ADDR = 4'h0;
            BUS_WDATA = 32'd5;
            @(posedge CLK);
            BUS_WE = 0;
            repeat(6) @(posedge CLK);


            RST_N = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(32'd0, 1'b0);
            RST_N = 1;
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
        input [31:0] expected_BUS_RDATA;
        input expected_EXPIRED;
        begin
            if (expected_BUS_RDATA === (expected_BUS_RDATA ^ BUS_RDATA ^ expected_BUS_RDATA) &&
                expected_EXPIRED === (expected_EXPIRED ^ EXPIRED ^ expected_EXPIRED)) begin
                $display("PASS");
                $display("  Outputs: BUS_RDATA=%h, EXPIRED=%b",
                         BUS_RDATA, EXPIRED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUS_RDATA=%h, EXPIRED=%b",
                         expected_BUS_RDATA, expected_EXPIRED);
                $display("  Got:      BUS_RDATA=%h, EXPIRED=%b",
                         BUS_RDATA, EXPIRED);
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
        $dumpvars(0,BUS_ADDR, BUS_WDATA, BUS_WE, CLK, RST_N, BUS_RDATA, EXPIRED);
    end

endmodule
