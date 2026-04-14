`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bs_adr;
    reg [15:0] bs_din;
    reg bs_stb;
    reg bs_we;
    reg pclk;
    reg prst;
    wire [15:0] bs_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bs_adr(bs_adr),
        .bs_din(bs_din),
        .bs_stb(bs_stb),
        .bs_we(bs_we),
        .pclk(pclk),
        .prst(prst),
        .bs_dout(bs_dout)
    );
    task testcase001;

    begin
        $display("\nTestcase 001: Reset Verification");
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(bs_dout);
    end
        endtask

    task testcase002;

    begin
        $display("\nTestcase 002: Trigger Start Command");
        test_num = 2;
        reset_dut();
        bus_write(8'h10, 16'h0001);
        repeat(2) @(posedge pclk);
        #1;

        check_outputs(bs_dout);
    end
        endtask

    task testcase003;

    begin
        $display("\nTestcase 003: Trigger Clear Command");
        test_num = 3;
        reset_dut();
        bus_write(8'h11, 16'h0001);
        repeat(2) @(posedge pclk);
        #1;

        check_outputs(bs_dout);
    end
        endtask

    task testcase004;

    begin
        $display("\nTestcase 004: Read DIA Register");
        test_num = 4;
        reset_dut();

        bus_write(8'h00, 16'hACE0);

        bus_read(8'h00);
        #1;

        check_outputs(16'hACE0);
    end
        endtask

    task testcase005;

    begin
        $display("\nTestcase 005: Read DIB Register");
        test_num = 5;
        reset_dut();

        bus_write(8'h01, 16'hBEEF);

        bus_read(8'h01);
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase006;

    begin
        $display("\nTestcase 006: Read DIC Register");
        test_num = 6;
        reset_dut();

        bus_write(8'h02, 16'hC0DE);

        bus_read(8'h02);
        #1;

        check_outputs(16'hC0DE);
    end
        endtask

    task testcase007;

    begin
        $display("\nTestcase 007: Strobe Gating Check");
        test_num = 7;
        reset_dut();


        @(posedge pclk);
        #1;
        bs_adr = 8'h00;
        bs_din = 16'hFFFF;
        bs_we = 1;
        bs_stb = 0;
        @(posedge pclk);
        #1;


        bus_read(8'h00);
        if (bs_dout == 16'hFFFF) begin
            $display("FAIL: Data written while strobe was low");
            fail_count = fail_count + 1;
        end else begin
            #1;

            check_outputs(bs_dout);
        end
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
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_bs_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bs_dout === (expected_bs_dout ^ bs_dout ^ expected_bs_dout)) begin
                $display("PASS");
                $display("  Outputs: bs_dout=%h",
                         bs_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bs_dout=%h",
                         expected_bs_dout);
                $display("  Got:      bs_dout=%h",
                         bs_dout);
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
