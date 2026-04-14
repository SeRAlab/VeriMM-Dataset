`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] avs_s0_address;
    reg avs_s0_read;
    reg avs_s0_write;
    reg [31:0] avs_s0_writedata;
    reg clock_clk;
    reg reset_reset;
    wire LEDR;
    wire [31:0] avs_s0_readdata;
    wire avs_s0_waitrequest;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avs_s0_address(avs_s0_address),
        .avs_s0_read(avs_s0_read),
        .avs_s0_write(avs_s0_write),
        .avs_s0_writedata(avs_s0_writedata),
        .clock_clk(clock_clk),
        .reset_reset(reset_reset),
        .LEDR(LEDR),
        .avs_s0_readdata(avs_s0_readdata),
        .avs_s0_waitrequest(avs_s0_waitrequest)
    );

    // Clock generation (10ns period)
    initial begin
        clock_clk = 0;
        forever #5 clock_clk = ~clock_clk;
    end

        task reset_dut;

        begin
            reset_reset = 1;
            avs_s0_address = 4'h0;
            avs_s0_read = 0;
            avs_s0_write = 0;
            avs_s0_writedata = 32'h0;
            repeat(2) @(posedge clock_clk);
            reset_reset = 0;
            @(posedge clock_clk);
        end
        endtask
    task avalon_write;

        input [3:0] addr;
        input [31:0] data;
        begin
            avs_s0_address = addr;
            avs_s0_writedata = data;
            avs_s0_write = 1;
            @(posedge clock_clk);
            while (avs_s0_waitrequest) @(posedge clock_clk);
            avs_s0_write = 0;
            @(posedge clock_clk);
        end
        endtask

    task avalon_read;

        input [3:0] addr;
        begin
            avs_s0_address = addr;
            avs_s0_read = 1;
            @(posedge clock_clk);
            while (avs_s0_waitrequest) @(posedge clock_clk);

            avs_s0_read = 0;
            @(posedge clock_clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Write to Address 1 and Read Back", test_num);
            reset_dut();
            avalon_write(4'h1, 32'hDEADBEEF);
            avalon_read(4'h1);

            #1;


            check_outputs(1'b0, 32'hDEADBEEF, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Toggle LEDR High via Address 0", test_num);
            reset_dut();
            avalon_write(4'h0, 32'h00000001);
            avalon_read(4'h0);
            #1;

            check_outputs(1'b1, 32'h00000001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Toggle LEDR Low via Address 0", test_num);
            reset_dut();
            avalon_write(4'h0, 32'h00000001);
            avalon_write(4'h0, 32'h00000000);
            avalon_read(4'h0);
            #1;

            check_outputs(1'b0, 32'h00000000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Test Highest Address (0xF)", test_num);
            reset_dut();
            avalon_write(4'hF, 32'h55AA55AA);
            avalon_read(4'hF);
            #1;

            check_outputs(1'b0, 32'h55AA55AA, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Check Reset Values", test_num);
            reset_dut();

            avalon_read(4'h1);
            #1;

            check_outputs(1'b0, 32'h00000000, 1'b0);
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
        input expected_LEDR;
        input [31:0] expected_avs_s0_readdata;
        input expected_avs_s0_waitrequest;
        begin
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR) &&
                expected_avs_s0_readdata === (expected_avs_s0_readdata ^ avs_s0_readdata ^ expected_avs_s0_readdata) &&
                expected_avs_s0_waitrequest === (expected_avs_s0_waitrequest ^ avs_s0_waitrequest ^ expected_avs_s0_waitrequest)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%b, avs_s0_readdata=%h, avs_s0_waitrequest=%b",
                         LEDR, avs_s0_readdata, avs_s0_waitrequest);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%b, avs_s0_readdata=%h, avs_s0_waitrequest=%b",
                         expected_LEDR, expected_avs_s0_readdata, expected_avs_s0_waitrequest);
                $display("  Got:      LEDR=%b, avs_s0_readdata=%h, avs_s0_waitrequest=%b",
                         LEDR, avs_s0_readdata, avs_s0_waitrequest);
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
        $dumpvars(0,avs_s0_address, avs_s0_read, avs_s0_write, avs_s0_writedata, clock_clk, reset_reset, LEDR, avs_s0_readdata, avs_s0_waitrequest);
    end

endmodule
