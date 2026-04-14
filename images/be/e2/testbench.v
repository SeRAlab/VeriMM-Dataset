`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BCLK;
    reg [31:0] BYDIN;
    reg [31:0] DIN;
    reg DOWR;
    reg ENWR;
    reg [7:0] RADR;
    reg [5:0] WADR;
    reg [1:0] WMASKE;
    wire [31:0] DOUT;
    wire SELI;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BCLK(BCLK),
        .BYDIN(BYDIN),
        .DIN(DIN),
        .DOWR(DOWR),
        .ENWR(ENWR),
        .RADR(RADR),
        .WADR(WADR),
        .WMASKE(WMASKE),
        .DOUT(DOUT),
        .SELI(SELI)
    );

    // Clock generation (10ns period)
    initial begin
        BCLK = 0;
        forever #5 BCLK = ~BCLK;
    end

        task reset_dut;

    begin
        ENWR = 0;
        DOWR = 0;
        BYDIN = 32'h0;
        DIN = 32'h0;
        RADR = 8'h0;
        WADR = 6'h0;
        WMASKE = 2'b00;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write and Read", test_num);
        reset_dut();


        @(negedge BCLK);
        WADR = 6'd5;
        DIN = 32'h12345678;
        WMASKE = 2'b11;
        ENWR = 1;

        @(negedge BCLK);
        ENWR = 0;


        RADR = 8'd5;
        #2;
        #1;

        check_outputs(32'h12345678, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write Enable (ENWR) Check", test_num);
        reset_dut();


        @(negedge BCLK);
        WADR = 6'd10;
        DIN = 32'hFFFF_FFFF;
        WMASKE = 2'b11;
        ENWR = 0;

        @(negedge BCLK);
        RADR = 8'd10;
        #2;

        #1;


        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Boundary Address (Max WADR)", test_num);
        reset_dut();

        @(negedge BCLK);
        WADR = 6'd63;
        DIN = 32'hA5A5_B6B6;
        WMASKE = 2'b11;
        ENWR = 1;

        @(negedge BCLK);
        ENWR = 0;
        RADR = 8'd63;
        #2;
        #1;

        check_outputs(32'hA5A5_B6B6, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: RADR Out of Range Check", test_num);
        reset_dut();

        @(negedge BCLK);
        RADR = 8'd64;
        #2;

        #1;


        check_outputs(32'h0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Bypass Path (DOWR/BYDIN)", test_num);
        reset_dut();

        @(negedge BCLK);
        BYDIN = 32'hBEEF_CAFE;
        DOWR = 1;
        RADR = 8'd0;
        #2;

        #1;


        check_outputs(32'hBEEF_CAFE, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write Masking Check", test_num);
        reset_dut();


        @(negedge BCLK);
        WADR = 6'd20;
        DIN = 32'h1111_2222;
        WMASKE = 2'b01;
        ENWR = 1;

        @(negedge BCLK);

        WADR = 6'd20;
        DIN = 32'hAAAA_BBBB;
        WMASKE = 2'b10;
        ENWR = 1;

        @(negedge BCLK);
        ENWR = 0;
        RADR = 8'd20;
        #2;

        #1;


        check_outputs(32'hAAAA_2222, 1'b1);
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
        input [31:0] expected_DOUT;
        input expected_SELI;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT) &&
                expected_SELI === (expected_SELI ^ SELI ^ expected_SELI)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h, SELI=%b",
                         DOUT, SELI);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h, SELI=%b",
                         expected_DOUT, expected_SELI);
                $display("  Got:      DOUT=%h, SELI=%b",
                         DOUT, SELI);
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
        $dumpvars(0,BCLK, BYDIN, DIN, DOWR, ENWR, RADR, WADR, WMASKE, DOUT, SELI);
    end

endmodule
