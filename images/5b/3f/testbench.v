`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg MemoryWrite;
    reg [4:0] address;
    reg clock;
    reg out;
    reg reset;
    reg [31:0] writedata;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MemoryWrite(MemoryWrite),
        .address(address),
        .clock(clock),
        .out(out),
        .reset(reset),
        .writedata(writedata),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            reset = 1;
            MemoryWrite = 0;
            address = 0;
            writedata = 0;
            out = 0;
            @(negedge clock);
            reset = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clock);
            address = 5;
            writedata = 32'hABCD1234;
            MemoryWrite = 1;
            out = 0;

            @(negedge clock);
            MemoryWrite = 0;
            out = 1;

            @(negedge clock);
            #1;

            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Persistence at Different Addresses", test_num);
            reset_dut();


            @(negedge clock);
            address = 10;
            writedata = 32'h11112222;
            MemoryWrite = 1;


            @(negedge clock);
            address = 20;
            writedata = 32'h33334444;
            MemoryWrite = 1;

            @(negedge clock);
            MemoryWrite = 0;
            address = 10;
            out = 1;

            @(negedge clock);
            #1;

            check_outputs(32'h11112222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Memory Address", test_num);
            reset_dut();


            @(negedge clock);
            address = 15;
            writedata = 32'hAAAAAAAA;
            MemoryWrite = 1;


            @(negedge clock);
            writedata = 32'h55555555;

            @(negedge clock);
            MemoryWrite = 0;
            out = 1;

            @(negedge clock);
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset following mem[0] update", test_num);
            reset_dut();


            @(negedge clock);
            address = 0;
            writedata = 32'hFEEDFACE;
            MemoryWrite = 1;

            @(negedge clock);
            MemoryWrite = 0;
            reset = 1;

            @(negedge clock);
            reset = 0;


            #1;



            check_outputs(32'hFEEDFACE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check (31)", test_num);
            reset_dut();

            @(negedge clock);
            address = 5'd31;
            writedata = 32'hFFFFFFFF;
            MemoryWrite = 1;

            @(negedge clock);
            MemoryWrite = 0;
            out = 1;

            @(negedge clock);
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,MemoryWrite, address, clock, out, reset, writedata, dataout);
    end

endmodule
