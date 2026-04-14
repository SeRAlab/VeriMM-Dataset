`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [35:0] m_readdata;
    reg m_waitrequest;
    reg reset;
    reg [17:0] s0_address;
    reg s0_read;
    reg s0_write;
    reg [35:0] s0_writedata;
    reg [17:0] s1_address;
    reg s1_read;
    reg s1_write;
    reg [35:0] s1_writedata;
    wire [17:0] m_address;
    wire m_read;
    wire m_write;
    wire [35:0] m_writedata;
    wire [35:0] s0_readdata;
    wire s0_waitrequest;
    wire [35:0] s1_readdata;
    wire s1_waitrequest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m_readdata(m_readdata),
        .m_waitrequest(m_waitrequest),
        .reset(reset),
        .s0_address(s0_address),
        .s0_read(s0_read),
        .s0_write(s0_write),
        .s0_writedata(s0_writedata),
        .s1_address(s1_address),
        .s1_read(s1_read),
        .s1_write(s1_write),
        .s1_writedata(s1_writedata),
        .m_address(m_address),
        .m_read(m_read),
        .m_write(m_write),
        .m_writedata(m_writedata),
        .s0_readdata(s0_readdata),
        .s0_waitrequest(s0_waitrequest),
        .s1_readdata(s1_readdata),
        .s1_waitrequest(s1_waitrequest)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            s0_address = 0; s0_read = 0; s0_write = 0; s0_writedata = 0;
            s1_address = 0; s1_read = 0; s1_write = 0; s1_writedata = 0;
            m_readdata = 0; m_waitrequest = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            s0_address = 18'h1AAAA;
            s0_write = 1;
            s0_writedata = 36'hCAFEBABE0;
            m_waitrequest = 0;

            #1;


            check_outputs(18'h1AAAA, 0, 1, 36'hCAFEBABE0, 36'h0, 0, 36'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            s1_address = 18'h2BBBB;
            s1_read = 1;
            m_readdata = 36'hDEADBEEF1;
            m_waitrequest = 0;

            #1;


            check_outputs(18'h2BBBB, 1, 0, 36'h0, 36'h0, 0, 36'hDEADBEEF1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            s0_address = 18'h00001;
            s0_read = 1;
            s1_address = 18'h00002;
            s1_write = 1;
            s1_writedata = 36'hFFFFFFFFF;
            m_readdata = 36'h111111111;
            m_waitrequest = 0;

            #1;


            check_outputs(18'h00001, 1, 0, 36'h0, 36'h111111111, 0, 36'h0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            s0_address = 18'h3CCCC;
            s0_write = 1;
            s0_writedata = 36'h555555555;
            m_waitrequest = 1;

            #1;


            check_outputs(18'h3CCCC, 0, 1, 36'h555555555, 36'h0, 1, 36'h0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            s0_address = 18'h0000A; s0_read = 1;
            @(posedge clk); #1;

            s0_read = 0;
            s1_address = 18'h0000B; s1_read = 1;
            m_readdata = 36'hBBBBBBBBB;
            #1;

            check_outputs(18'h0000B, 1, 0, 36'h0, 36'h0, 0, 36'hBBBBBBBBB, 0);
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
        input [17:0] expected_m_address;
        input expected_m_read;
        input expected_m_write;
        input [35:0] expected_m_writedata;
        input [35:0] expected_s0_readdata;
        input expected_s0_waitrequest;
        input [35:0] expected_s1_readdata;
        input expected_s1_waitrequest;
        begin
            if (expected_m_address === (expected_m_address ^ m_address ^ expected_m_address) &&
                expected_m_read === (expected_m_read ^ m_read ^ expected_m_read) &&
                expected_m_write === (expected_m_write ^ m_write ^ expected_m_write) &&
                expected_m_writedata === (expected_m_writedata ^ m_writedata ^ expected_m_writedata) &&
                expected_s0_readdata === (expected_s0_readdata ^ s0_readdata ^ expected_s0_readdata) &&
                expected_s0_waitrequest === (expected_s0_waitrequest ^ s0_waitrequest ^ expected_s0_waitrequest) &&
                expected_s1_readdata === (expected_s1_readdata ^ s1_readdata ^ expected_s1_readdata) &&
                expected_s1_waitrequest === (expected_s1_waitrequest ^ s1_waitrequest ^ expected_s1_waitrequest)) begin
                $display("PASS");
                $display("  Outputs: m_address=%h, m_read=%b, m_write=%b, m_writedata=%h, s0_readdata=%h, s0_waitrequest=%b, s1_readdata=%h, s1_waitrequest=%b",
                         m_address, m_read, m_write, m_writedata, s0_readdata, s0_waitrequest, s1_readdata, s1_waitrequest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_address=%h, m_read=%b, m_write=%b, m_writedata=%h, s0_readdata=%h, s0_waitrequest=%b, s1_readdata=%h, s1_waitrequest=%b",
                         expected_m_address, expected_m_read, expected_m_write, expected_m_writedata, expected_s0_readdata, expected_s0_waitrequest, expected_s1_readdata, expected_s1_waitrequest);
                $display("  Got:      m_address=%h, m_read=%b, m_write=%b, m_writedata=%h, s0_readdata=%h, s0_waitrequest=%b, s1_readdata=%h, s1_waitrequest=%b",
                         m_address, m_read, m_write, m_writedata, s0_readdata, s0_waitrequest, s1_readdata, s1_waitrequest);
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
        $dumpvars(0,clk, m_readdata, m_waitrequest, reset, s0_address, s0_read, s0_write, s0_writedata, s1_address, s1_read, s1_write, s1_writedata, m_address, m_read, m_write, m_writedata, s0_readdata, s0_waitrequest, s1_readdata, s1_waitrequest);
    end

endmodule
