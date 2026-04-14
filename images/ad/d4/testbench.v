`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] MASK;
    reg [10:0] RADDR;
    reg RCLK;
    reg RCLKE;
    reg RE;
    reg [10:0] WADDR;
    reg WCLK;
    reg WCLKE;
    reg [15:0] WDATA;
    reg WE;
    wire [15:0] RDATA_0;
    wire [7:0] RDATA_1;
    wire [1:0] RDATA_3;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MASK(MASK),
        .RADDR(RADDR),
        .RCLK(RCLK),
        .RCLKE(RCLKE),
        .RE(RE),
        .WADDR(WADDR),
        .WCLK(WCLK),
        .WCLKE(WCLKE),
        .WDATA(WDATA),
        .WE(WE),
        .RDATA_0(RDATA_0),
        .RDATA_1(RDATA_1),
        .RDATA_3(RDATA_3),
        .X(X)
    );

    // Clock generation (10ns period)
    initial begin
        WCLK = 0;
        forever #5 WCLK = ~WCLK;
    end

        task reset_dut;

        begin
            MASK = 0;
            RADDR = 0;
            RCLKE = 0;
            RE = 0;
            WADDR = 0;
            WCLKE = 0;
            WDATA = 0;
            WE = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Simple Write and Read");
            reset_dut();
            write_mem(11'h000, 16'hABCD, 16'hFFFF);
            read_mem(11'h000);

            #1;


            check_outputs(16'hABCD, 8'hCD, 2'b01, X);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Masked Write");
            reset_dut();

            write_mem(11'h010, 16'h0000, 16'hFFFF);

            write_mem(11'h010, 16'h55AA, 16'hFF00);
            read_mem(11'h010);

            #1;


            check_outputs(16'h5500, 8'h00, 2'b00, X);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Boundary Address Check");
            reset_dut();
            write_mem(11'h0FF, 16'hF0F0, 16'hFFFF);
            read_mem(11'h0FF);
            #1;

            check_outputs(16'hF0F0, 8'hF0, 2'b00, X);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Write Clock Enable Disable");
            reset_dut();

            write_mem(11'h005, 16'h1111, 16'hFFFF);


            @(posedge WCLK);
            WADDR = 11'h005;
            WDATA = 11'hEEEE;
            WE = 1;
            WCLKE = 0;
            @(posedge WCLK);
            WE = 0;

            read_mem(11'h005);

            #1;


            check_outputs(16'h1111, 8'h11, 2'b01, X);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Read Clock Enable Disable");
            reset_dut();
            write_mem(11'h020, 16'hAAAA, 16'hFFFF);
            write_mem(11'h021, 16'hBBBB, 16'hFFFF);


            read_mem(11'h020);


            @(posedge RCLK);
            RADDR = 11'h021;
            RE = 1;
            RCLKE = 0;
            @(posedge RCLK);
            #1;


            #1;



            check_outputs(16'hAAAA, 8'hAA, 2'b10, X);
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
        input [15:0] expected_RDATA_0;
        input [7:0] expected_RDATA_1;
        input [1:0] expected_RDATA_3;
        input expected_X;
        begin
            if (expected_RDATA_0 === (expected_RDATA_0 ^ RDATA_0 ^ expected_RDATA_0) &&
                expected_RDATA_1 === (expected_RDATA_1 ^ RDATA_1 ^ expected_RDATA_1) &&
                expected_RDATA_3 === (expected_RDATA_3 ^ RDATA_3 ^ expected_RDATA_3) &&
                expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: RDATA_0=%h, RDATA_1=%h, RDATA_3=%h, X=%b",
                         RDATA_0, RDATA_1, RDATA_3, X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RDATA_0=%h, RDATA_1=%h, RDATA_3=%h, X=%b",
                         expected_RDATA_0, expected_RDATA_1, expected_RDATA_3, expected_X);
                $display("  Got:      RDATA_0=%h, RDATA_1=%h, RDATA_3=%h, X=%b",
                         RDATA_0, RDATA_1, RDATA_3, X);
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
        $dumpvars(0,MASK, RADDR, RCLK, RCLKE, RE, WADDR, WCLK, WCLKE, WDATA, WE, RDATA_0, RDATA_1, RDATA_3, X);
    end

endmodule
