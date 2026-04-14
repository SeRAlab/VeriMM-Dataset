`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg rP;
    reg [31:0] target;
    reg wP;
    reg [31:0] writeData;
    wire [31:0] readData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .rP(rP),
        .target(target),
        .wP(wP),
        .writeData(writeData),
        .readData(readData)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rP = 0;
            wP = 0;
            target = 0;
            writeData = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read back", test_num);
            reset_dut();


            wP = 1;
            target = 32'd10;
            writeData = 32'h12345678;
            @(posedge clock);
            #1;
            wP = 0;


            rP = 1;
            target = 32'd10;
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read enable (rP) low check", test_num);
            reset_dut();


            wP = 1;
            target = 32'd20;
            writeData = 32'hABCDEF01;
            @(posedge clock);
            #1;
            wP = 0;


            rP = 0;
            target = 32'd20;
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary address (127) check", test_num);
            reset_dut();

            wP = 1;
            target = 32'd127;
            writeData = 32'hFFFFFFFF;
            @(posedge clock);
            #1;
            wP = 0;
            rP = 1;
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite memory location", test_num);
            reset_dut();


            wP = 1;
            target = 32'd50;
            writeData = 32'hAAAA_AAAA;
            @(posedge clock);
            #1;


            writeData = 32'h5555_5555;
            @(posedge clock);
            #1;
            wP = 0;


            rP = 1;
            target = 32'd50;
            #2;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write enable (wP) low check", test_num);
            reset_dut();


            wP = 1;
            target = 32'd5;
            writeData = 32'hCAFE_BABE;
            @(posedge clock);
            #1;


            wP = 0;
            writeData = 32'hDEAD_BEEF;
            @(posedge clock);
            #1;


            rP = 1;
            target = 32'd5;
            #2;
            #1;

            check_outputs(32'hCAFE_BABE);
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
        input [31:0] expected_readData;
        begin
            if (expected_readData === (expected_readData ^ readData ^ expected_readData)) begin
                $display("PASS");
                $display("  Outputs: readData=%h",
                         readData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readData=%h",
                         expected_readData);
                $display("  Got:      readData=%h",
                         readData);
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
        $dumpvars(0,clock, rP, target, wP, writeData, readData);
    end

endmodule
