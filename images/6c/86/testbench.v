`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] address;
    reg clock;
    reg [15:0] data_in;
    reg enable;
    reg write;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .data_in(data_in),
        .enable(enable),
        .write(write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;
            enable = 0;
            write = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            enable = 1;
            write = 1;
            address = 14'h0010;
            data_in = 16'hABCD;
            @(posedge clock);
            #1;


            write = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Boundary Address (Max)", test_num);


            enable = 1;
            write = 1;
            address = 14'h3FFF;
            data_in = 16'h55AA;
            @(posedge clock);
            #1;


            write = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwrite Data", test_num);


            enable = 1;
            write = 1;
            address = 14'h0100;
            data_in = 16'h1111;
            @(posedge clock);
            #1;


            data_in = 16'h2222;
            @(posedge clock);
            #1;


            write = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Enable Signal Gating (Write)", test_num);


            enable = 1;
            write = 1;
            address = 14'h0005;
            data_in = 16'hAAAA;
            @(posedge clock);
            #1;


            enable = 0;
            write = 1;
            data_in = 16'hFFFF;
            @(posedge clock);
            #1;


            enable = 1;
            write = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Sequential Access", test_num);

            enable = 1;
            write = 1;


            address = 14'h1;
            data_in = 16'hC0DE;
            @(posedge clock);
            #1;


            address = 14'h2;
            data_in = 16'hBEEF;
            @(posedge clock);
            #1;


            write = 0;
            address = 14'h1;
            @(posedge clock);
            #1;


            address = 14'h2;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hBEEF);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,address, clock, data_in, enable, write, data_out);
    end

endmodule
