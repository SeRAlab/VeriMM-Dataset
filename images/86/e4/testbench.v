`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] address;
    reg clock;
    reg [11:0] data_in;
    reg write_en;
    wire [11:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .data_in(data_in),
        .write_en(write_en),
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
            write_en = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Basic Write and Read at Address 0x055", test_num);
            reset_dut();

            address = 10'h055;
            data_in = 12'hABC;
            write_en = 1;
            @(posedge clock);
            #2;
            write_en = 0;

            #1;


            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Write Enable Low Verification", test_num);
            reset_dut();


            address = 10'h1AA;
            data_in = 12'h111;
            write_en = 1;
            @(posedge clock);
            #2;


            data_in = 12'hEEE;
            write_en = 0;
            @(posedge clock);
            #2;

            #1;


            check_outputs(12'h111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Boundary Address Check (Addr 1023)", test_num);
            reset_dut();

            address = 10'd1023;
            data_in = 12'hFFF;
            write_en = 1;
            @(posedge clock);
            #2;
            write_en = 0;

            #1;


            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Boundary Address Check (Addr 0)", test_num);
            reset_dut();

            address = 10'd0;
            data_in = 12'h5A5;
            write_en = 1;
            @(posedge clock);
            #2;
            write_en = 0;

            #1;


            check_outputs(12'h5A5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Overwriting existing data", test_num);
            reset_dut();

            address = 10'h222;
            data_in = 12'h123;
            write_en = 1;
            @(posedge clock);
            #2;

            data_in = 12'h987;
            @(posedge clock);
            #2;
            write_en = 0;

            #1;


            check_outputs(12'h987);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Multiple address non-interference", test_num);
            reset_dut();


            address = 10'h001;
            data_in = 12'hAAA;
            write_en = 1;
            @(posedge clock);
            #2;


            address = 10'h002;
            data_in = 12'hBBB;
            @(posedge clock);
            #2;


            write_en = 0;
            address = 10'h001;
            #2;

            #1;


            check_outputs(12'hAAA);
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
        input [11:0] expected_data_out;
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
        $dumpvars(0,address, clock, data_in, write_en, data_out);
    end

endmodule
