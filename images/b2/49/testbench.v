`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] BusW;
    reg Clk;
    reg [4:0] RA;
    reg [4:0] RB;
    reg [4:0] RW;
    reg RegWr;
    wire [63:0] BusA;
    wire [63:0] BusB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BusW(BusW),
        .Clk(Clk),
        .RA(RA),
        .RB(RB),
        .RW(RW),
        .RegWr(RegWr),
        .BusA(BusA),
        .BusB(BusB)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            RegWr = 0;
            RW = 0;
            RA = 0;
            RB = 0;
            BusW = 0;

            @(negedge Clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Write to Reg 1 and Read back");


            RW = 5'd1;
            BusW = 64'hFEDCBA9876543210;
            RegWr = 1;


            @(negedge Clk);
            RegWr = 0;


            RA = 5'd1;
            RB = 5'd1;

            #2;
            #1;

            check_outputs(64'hFEDCBA9876543210, 64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Verify Reg 31 always returns 0");


            RW = 5'd31;
            BusW = 64'hFFFFFFFFFFFFFFFF;
            RegWr = 1;

            @(negedge Clk);
            RegWr = 0;


            RA = 5'd31;
            RB = 5'd31;

            #2;
            #1;

            check_outputs(64'h0, 64'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Verify RegWr=0 prevents writing");


            RW = 5'd5;
            BusW = 64'hAAAA_AAAA_AAAA_AAAA;
            RegWr = 1;
            @(negedge Clk);


            BusW = 64'hBBBB_BBBB_BBBB_BBBB;
            RegWr = 0;
            @(negedge Clk);


            RA = 5'd5;
            RB = 5'd5;

            #2;

            #1;


            check_outputs(64'hAAAA_AAAA_AAAA_AAAA, 64'hAAAA_AAAA_AAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Simultaneous read from different registers");


            RW = 5'd10;
            BusW = 64'h1111_2222_3333_4444;
            RegWr = 1;
            @(negedge Clk);


            RW = 5'd20;
            BusW = 64'h5555_6666_7777_8888;
            RegWr = 1;
            @(negedge Clk);
            RegWr = 0;


            RA = 5'd10;
            RB = 5'd20;

            #2;
            #1;

            check_outputs(64'h1111_2222_3333_4444, 64'h5555_6666_7777_8888);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Verify Reg 0 behaves as a normal register");

            RW = 5'd0;
            BusW = 64'hCAFEBABE_DEADBEEF;
            RegWr = 1;
            @(negedge Clk);
            RegWr = 0;

            RA = 5'd0;
            RB = 5'd31;

            #2;
            #1;

            check_outputs(64'hCAFEBABE_DEADBEEF, 64'h0);
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
        input [63:0] expected_BusA;
        input [63:0] expected_BusB;
        begin
            if (expected_BusA === (expected_BusA ^ BusA ^ expected_BusA) &&
                expected_BusB === (expected_BusB ^ BusB ^ expected_BusB)) begin
                $display("PASS");
                $display("  Outputs: BusA=%h, BusB=%h",
                         BusA, BusB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusA=%h, BusB=%h",
                         expected_BusA, expected_BusB);
                $display("  Got:      BusA=%h, BusB=%h",
                         BusA, BusB);
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
        $dumpvars(0,BusW, Clk, RA, RB, RW, RegWr, BusA, BusB);
    end

endmodule
