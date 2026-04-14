`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] address_port1;
    reg [11:0] address_port2;
    reg clock;
    reg [15:0] data_in_port1;
    reg [15:0] data_in_port2;
    reg output_enable_port1;
    reg output_enable_port2;
    reg write_enable_port1;
    reg write_enable_port2;
    wire [15:0] data_out_port1;
    wire [15:0] data_out_port2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_port1(address_port1),
        .address_port2(address_port2),
        .clock(clock),
        .data_in_port1(data_in_port1),
        .data_in_port2(data_in_port2),
        .output_enable_port1(output_enable_port1),
        .output_enable_port2(output_enable_port2),
        .write_enable_port1(write_enable_port1),
        .write_enable_port2(write_enable_port2),
        .data_out_port1(data_out_port1),
        .data_out_port2(data_out_port2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address_port1 = 12'b0;
            address_port2 = 12'b0;
            data_in_port1 = 16'b0;
            data_in_port2 = 16'b0;
            write_enable_port1 = 1'b0;
            write_enable_port2 = 1'b0;
            output_enable_port1 = 1'b0;
            output_enable_port2 = 1'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Port 1 Write/Read...");
            test_num = test_num + 1;
            reset_dut();


            address_port1 = 12'hABC;
            data_in_port1 = 16'h1234;
            write_enable_port1 = 1'b1;
            @(posedge clock);
            #1;


            write_enable_port1 = 1'b0;
            output_enable_port1 = 1'b1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h1234, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Port 2 Write/Read...");
            test_num = test_num + 1;
            reset_dut();


            address_port2 = 12'h555;
            data_in_port2 = 16'h5A5A;
            write_enable_port2 = 1'b1;
            @(posedge clock);
            #1;


            write_enable_port2 = 1'b0;
            output_enable_port2 = 1'b1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h0000, 16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Concurrent Dual Port Access...");
            test_num = test_num + 1;
            reset_dut();


            address_port1 = 12'h001;
            data_in_port1 = 16'h1111;
            write_enable_port1 = 1'b1;

            address_port2 = 12'h002;
            data_in_port2 = 16'h2222;
            write_enable_port2 = 1'b1;
            @(posedge clock);
            #1;


            write_enable_port1 = 1'b0;
            write_enable_port2 = 1'b0;
            output_enable_port1 = 1'b1;
            output_enable_port2 = 1'b1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Cross-Port Access (P1 Write, P2 Read)...");
            test_num = test_num + 1;
            reset_dut();


            address_port1 = 12'hF0F;
            data_in_port1 = 16'hCAFE;
            write_enable_port1 = 1'b1;
            @(posedge clock);
            #1;


            write_enable_port1 = 1'b0;
            address_port2 = 12'hF0F;
            output_enable_port2 = 1'b1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h0000, 16'hCAFE);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary and Output Enable logic...");
            test_num = test_num + 1;
            reset_dut();


            address_port2 = 12'hFFF;
            data_in_port2 = 16'hBEEF;
            write_enable_port2 = 1'b1;
            @(posedge clock);
            #1;


            write_enable_port2 = 1'b0;
            output_enable_port2 = 1'b0;
            @(posedge clock);
            #1;


            output_enable_port2 = 1'b1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h0000, 16'hBEEF);
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
        input [15:0] expected_data_out_port1;
        input [15:0] expected_data_out_port2;
        begin
            if (expected_data_out_port1 === (expected_data_out_port1 ^ data_out_port1 ^ expected_data_out_port1) &&
                expected_data_out_port2 === (expected_data_out_port2 ^ data_out_port2 ^ expected_data_out_port2)) begin
                $display("PASS");
                $display("  Outputs: data_out_port1=%h, data_out_port2=%h",
                         data_out_port1, data_out_port2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_port1=%h, data_out_port2=%h",
                         expected_data_out_port1, expected_data_out_port2);
                $display("  Got:      data_out_port1=%h, data_out_port2=%h",
                         data_out_port1, data_out_port2);
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
        $dumpvars(0,address_port1, address_port2, clock, data_in_port1, data_in_port2, output_enable_port1, output_enable_port2, write_enable_port1, write_enable_port2, data_out_port1, data_out_port2);
    end

endmodule
