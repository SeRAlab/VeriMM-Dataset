`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] ram_addr;
    reg ram_cen;
    reg ram_clk;
    reg [15:0] ram_din;
    reg [1:0] ram_wen;
    wire [15:0] ram_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ram_addr(ram_addr),
        .ram_cen(ram_cen),
        .ram_clk(ram_clk),
        .ram_din(ram_din),
        .ram_wen(ram_wen),
        .ram_dout(ram_dout)
    );

    // Clock generation (10ns period)
    initial begin
        ram_clk = 0;
        forever #5 ram_clk = ~ram_clk;
    end

        task reset_dut;

    begin
        ram_addr = 0;
        ram_cen = 1;
        ram_wen = 2'b00;
        ram_din = 0;
        @(negedge ram_clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Full Word Write/Read (Addr: 0x0A, Data: 0xABCD)", test_num);
        reset_dut();


        @(negedge ram_clk);
        ram_cen = 0;
        ram_wen = 2'b11;
        ram_addr = 7'h0A;
        ram_din = 16'hABCD;


        @(negedge ram_clk);
        ram_wen = 2'b00;


        @(negedge ram_clk);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Lower Byte Write (0xFFFF -> 0xFF00)", test_num);
        reset_dut();


        @(negedge ram_clk);
        ram_cen = 0; ram_wen = 2'b11; ram_addr = 7'h10; ram_din = 16'hFFFF;


        @(negedge ram_clk);
        ram_wen = 2'b01; ram_din = 16'h1200;


        @(negedge ram_clk);
        ram_wen = 2'b00;
        @(negedge ram_clk);
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Upper Byte Write (0xFFFF -> 0x00FF)", test_num);
        reset_dut();


        @(negedge ram_clk);
        ram_cen = 0; ram_wen = 2'b11; ram_addr = 7'h15; ram_din = 16'hFFFF;


        @(negedge ram_clk);
        ram_wen = 2'b10; ram_din = 16'h0034;


        @(negedge ram_clk);
        ram_wen = 2'b00;
        @(negedge ram_clk);
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Chip Enable Disabled Write Check", test_num);
        reset_dut();


        @(negedge ram_clk);
        ram_cen = 0; ram_wen = 2'b11; ram_addr = 7'h20; ram_din = 16'h5555;


        @(negedge ram_clk);
        ram_cen = 1; ram_wen = 2'b11; ram_din = 16'hAAAA;


        @(negedge ram_clk);
        ram_cen = 0; ram_wen = 2'b00;
        @(negedge ram_clk);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write Mode Gating (WEN=00)", test_num);
        reset_dut();


        @(negedge ram_clk);
        ram_cen = 0; ram_wen = 2'b11; ram_addr = 7'h30; ram_din = 16'h1111;


        @(negedge ram_clk);
        ram_wen = 2'b00; ram_din = 16'hEEEE;


        @(negedge ram_clk);
        #1;

        check_outputs(16'h1111);
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
        input [15:0] expected_ram_dout;
        begin
            if (expected_ram_dout === (expected_ram_dout ^ ram_dout ^ expected_ram_dout)) begin
                $display("PASS");
                $display("  Outputs: ram_dout=%h",
                         ram_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ram_dout=%h",
                         expected_ram_dout);
                $display("  Got:      ram_dout=%h",
                         ram_dout);
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
        $dumpvars(0,ram_addr, ram_cen, ram_clk, ram_din, ram_wen, ram_dout);
    end

endmodule
