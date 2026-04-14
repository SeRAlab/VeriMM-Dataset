`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] ReadAddress1;
    reg [10:0] ReadAddress2;
    reg WE;
    reg [10:0] WriteAddress;
    reg [255:0] WriteBus;
    reg clock;
    wire [255:0] ReadBus1;
    wire [255:0] ReadBus2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadAddress1(ReadAddress1),
        .ReadAddress2(ReadAddress2),
        .WE(WE),
        .WriteAddress(WriteAddress),
        .WriteBus(WriteBus),
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
            WriteAddress = 0;
            WriteBus = 0;
            ReadAddress1 = 0;
            ReadAddress2 = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write to Address 10 and Dual Read", test_num);

            WE = 1;
            WriteAddress = 11'd10;
            WriteBus = {128{2'b10}};
            @(posedge clock);
            #1;
            WE = 0;
            ReadAddress1 = 11'd10;
            ReadAddress2 = 11'd10;
            #2;
            #1;

            check_outputs({128{2'b10}}, {128{2'b10}});
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Concurrent Read from Addr 50 and Addr 100", test_num);


            WE = 1;
            WriteAddress = 11'd50;
            WriteBus = {64{4'hC}};
            @(posedge clock);
            #1;

            WriteAddress = 11'd100;
            WriteBus = {64{4'h3}};
            @(posedge clock);
            #1;
            WE = 0;
            ReadAddress1 = 11'd50;
            ReadAddress2 = 11'd100;
            #2;
            #1;

            check_outputs({64{4'hC}}, {64{4'h3}});
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Verify WE=0 prevents data update", test_num);


            WE = 1;
            WriteAddress = 11'd200;
            WriteBus = 256'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clock);
            #1;

            WE = 0;
            WriteAddress = 11'd200;
            WriteBus = 256'h0000_0000_0000_0000;
            @(posedge clock);
            #1;
            ReadAddress1 = 11'd200;
            ReadAddress2 = 11'd0;
            #2;

            #1;


            check_outputs(256'hFFFF_FFFF_FFFF_FFFF, ReadBus2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Max Address Boundary (1799)", test_num);

            WE = 1;
            WriteAddress = 11'd1799;
            WriteBus = 256'hABCDE_F1234_56789;
            @(posedge clock);
            #1;
            WE = 0;
            ReadAddress1 = 11'd1799;
            ReadAddress2 = 11'd0;
            #2;
            #1;

            check_outputs(256'hABCDE_F1234_56789, ReadBus2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);


            WE = 1;
            WriteAddress = 11'd5;
            WriteBus = 256'h1111_2222_3333_4444;
            @(posedge clock);
            #1;


            WE = 1;
            WriteAddress = 11'd6;
            WriteBus = 256'h5555_6666_7777_8888;
            ReadAddress1 = 11'd5;
            @(posedge clock);
            #1;
            ReadAddress2 = 11'd6;
            #2;
            #1;

            check_outputs(256'h1111_2222_3333_4444, 256'h5555_6666_7777_8888);
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
        input [255:0] expected_ReadBus1;
        input [255:0] expected_ReadBus2;
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
        $dumpvars(0,ReadAddress1, ReadAddress2, WE, WriteAddress, WriteBus, clock, ReadBus1, ReadBus2);
    end

endmodule
