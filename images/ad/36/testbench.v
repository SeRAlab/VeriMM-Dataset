`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] ReadAddress1;
    reg [8:0] ReadAddress2;
    reg WE;
    reg [8:0] WriteAddress1;
    reg [8:0] WriteAddress2;
    reg [191:0] WriteBus1;
    reg [191:0] WriteBus2;
    reg clock;
    wire [191:0] ReadBus1;
    wire [191:0] ReadBus2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadAddress1(ReadAddress1),
        .ReadAddress2(ReadAddress2),
        .WE(WE),
        .WriteAddress1(WriteAddress1),
        .WriteAddress2(WriteAddress2),
        .WriteBus1(WriteBus1),
        .WriteBus2(WriteBus2),
        .clock(clock),
        .ReadBus1(ReadBus1),
        .ReadBus2(ReadBus2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            WE = 0;
            WriteAddress1 = 0;
            WriteAddress2 = 0;
            ReadAddress1 = 0;
            ReadAddress2 = 0;
            WriteBus1 = 0;
            WriteBus2 = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();

            @(posedge clock);
            WE = 1;
            WriteAddress1 = 9'h00A;
            WriteAddress2 = 9'h00B;
            WriteBus1 = 192'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            WriteBus2 = 192'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB;

            @(posedge clock);
            WE = 0;
            ReadAddress1 = 9'h00A;
            ReadAddress2 = 9'h00B;
            #2;

            #1;


            check_outputs(192'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
                          192'hBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Check", test_num);
            reset_dut();


            @(posedge clock);
            WE = 1;
            WriteAddress1 = 9'h050;
            WriteBus1 = 192'h111111111111111111111111111111111111111111111111;
            @(posedge clock);


            WE = 0;
            WriteAddress1 = 9'h050;
            WriteBus1 = 192'hEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE;
            @(posedge clock);

            ReadAddress1 = 9'h050;
            ReadAddress2 = 9'h000;
            #2;

            #1;


            check_outputs(192'h111111111111111111111111111111111111111111111111, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read (Same Address)", test_num);
            reset_dut();

            @(posedge clock);
            WE = 1;
            WriteAddress1 = 9'h1FF;
            WriteBus1 = 192'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            @(posedge clock);
            WE = 0;
            ReadAddress1 = 9'h1FF;
            ReadAddress2 = 9'h1FF;
            #2;

            #1;


            check_outputs(192'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
                          192'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address Check (0 and 511)", test_num);
            reset_dut();

            @(posedge clock);
            WE = 1;
            WriteAddress1 = 9'd0;
            WriteAddress2 = 9'd511;
            WriteBus1 = 192'h1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF;
            WriteBus2 = 192'hFEDCBA0987654321FEDCBA0987654321FEDCBA0987654321;

            @(posedge clock);
            WE = 0;
            ReadAddress1 = 9'd0;
            ReadAddress2 = 9'd511;
            #2;

            #1;


            check_outputs(192'h1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF,
                          192'hFEDCBA0987654321FEDCBA0987654321FEDCBA0987654321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Cross-Port Data Verification", test_num);
            reset_dut();


            @(posedge clock);
            WE = 1;
            WriteAddress1 = 9'h100;
            WriteAddress2 = 9'h101;
            WriteBus1 = 192'h777777777777777777777777777777777777777777777777;
            WriteBus2 = 192'h888888888888888888888888888888888888888888888888;

            @(posedge clock);
            WE = 0;

            ReadAddress1 = 9'h101;
            ReadAddress2 = 9'h100;
            #2;

            #1;


            check_outputs(192'h888888888888888888888888888888888888888888888888,
                          192'h777777777777777777777777777777777777777777777777);
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
        input [191:0] expected_ReadBus1;
        input [191:0] expected_ReadBus2;
        begin
            if (expected_ReadBus1 === (expected_ReadBus1 ^ ReadBus1 ^ expected_ReadBus1) &&
                expected_ReadBus2 === (expected_ReadBus2 ^ ReadBus2 ^ expected_ReadBus2)) begin
                $display("PASS");
                $display("  Outputs: ReadBus1=%h, ReadBus2=%h",
                         ReadBus1, ReadBus2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadBus1=%h, ReadBus2=%h",
                         expected_ReadBus1, expected_ReadBus2);
                $display("  Got:      ReadBus1=%h, ReadBus2=%h",
                         ReadBus1, ReadBus2);
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
        $dumpvars(0,ReadAddress1, ReadAddress2, WE, WriteAddress1, WriteAddress2, WriteBus1, WriteBus2, clock, ReadBus1, ReadBus2);
    end

endmodule
