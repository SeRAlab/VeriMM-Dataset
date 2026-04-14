`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg WriteEnable;
    reg clock;
    reg clock_debug;
    reg [4:0] read_address_1;
    reg [4:0] read_address_2;
    reg [4:0] read_address_3;
    reg [4:0] read_address_debug;
    reg reset;
    reg [4:0] write_address;
    reg [31:0] write_data_in;
    wire [31:0] data_out_1;
    wire [31:0] data_out_2;
    wire [31:0] data_out_3;
    wire [31:0] data_out_debug;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WriteEnable(WriteEnable),
        .clock(clock),
        .clock_debug(clock_debug),
        .read_address_1(read_address_1),
        .read_address_2(read_address_2),
        .read_address_3(read_address_3),
        .read_address_debug(read_address_debug),
        .reset(reset),
        .write_address(write_address),
        .write_data_in(write_data_in),
        .data_out_1(data_out_1),
        .data_out_2(data_out_2),
        .data_out_3(data_out_3),
        .data_out_debug(data_out_debug)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            WriteEnable = 0;
            write_address = 0;
            write_data_in = 0;
            read_address_1 = 0;
            read_address_2 = 0;
            read_address_3 = 0;
            read_address_debug = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset and Zero Register Check", test_num);
            reset_dut();

            read_address_1 = 0;
            read_address_2 = 5;
            read_address_3 = 31;
            read_address_debug = 15;

            #10;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write and Multi-port Read", test_num);
            reset_dut();

            @(posedge clock);
            WriteEnable = 1;
            write_address = 5'd1;
            write_data_in = 32'hABCDE123;

            @(posedge clock);
            #1;
            WriteEnable = 0;
            read_address_1 = 5'd1;
            read_address_2 = 5'd1;
            read_address_3 = 5'd1;
            read_address_debug = 5'd1;

            #10;
            #1;

            check_outputs(32'hABCDE123, 32'hABCDE123, 32'hABCDE123, 32'hABCDE123);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Register 0 Hardwired to Zero", test_num);
            reset_dut();

            @(posedge clock);
            WriteEnable = 1;
            write_address = 5'd0;
            write_data_in = 32'hFFFFFFFF;

            @(posedge clock);
            #1;
            WriteEnable = 0;
            read_address_1 = 5'd0;
            read_address_2 = 0;
            read_address_3 = 0;
            read_address_debug = 0;

            #10;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Multiple Writes and Distinct Reads", test_num);
            reset_dut();


            WriteEnable = 1;
            write_address = 5'd10;
            write_data_in = 32'h11112222;
            @(posedge clock);


            write_address = 5'd20;
            write_data_in = 32'h33334444;
            @(posedge clock);


            write_address = 5'd30;
            write_data_in = 32'h55556666;
            @(posedge clock);


            write_address = 5'd31;
            write_data_in = 32'h77778888;
            @(posedge clock);

            #1;
            WriteEnable = 0;
            read_address_1 = 5'd10;
            read_address_2 = 5'd20;
            read_address_3 = 5'd30;
            read_address_debug = 5'd31;

            #10;
            #1;

            check_outputs(32'h11112222, 32'h33334444, 32'h55556666, 32'h77778888);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write Enable Control Check", test_num);
            reset_dut();


            WriteEnable = 0;
            write_address = 5'd15;
            write_data_in = 32'hDEADBEEF;
            @(posedge clock);

            #1;
            read_address_1 = 5'd15;
            read_address_2 = 0;
            read_address_3 = 0;
            read_address_debug = 0;

            #10;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Back-to-back Write/Read", test_num);
            reset_dut();

            WriteEnable = 1;
            write_address = 5'd7;
            write_data_in = 32'hA5A55A5A;
            @(posedge clock);

            #1;
            WriteEnable = 0;
            read_address_1 = 5'd7;
            read_address_debug = 5'd7;

            #10;
            #1;

            check_outputs(32'hA5A55A5A, 32'h0, 32'h0, 32'hA5A55A5A);
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
        input [31:0] expected_data_out_1;
        input [31:0] expected_data_out_2;
        input [31:0] expected_data_out_3;
        input [31:0] expected_data_out_debug;
        begin
            if (expected_data_out_1 === (expected_data_out_1 ^ data_out_1 ^ expected_data_out_1) &&
                expected_data_out_2 === (expected_data_out_2 ^ data_out_2 ^ expected_data_out_2) &&
                expected_data_out_3 === (expected_data_out_3 ^ data_out_3 ^ expected_data_out_3) &&
                expected_data_out_debug === (expected_data_out_debug ^ data_out_debug ^ expected_data_out_debug)) begin
                $display("PASS");
                $display("  Outputs: data_out_1=%h, data_out_2=%h, data_out_3=%h, data_out_debug=%h",
                         data_out_1, data_out_2, data_out_3, data_out_debug);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_1=%h, data_out_2=%h, data_out_3=%h, data_out_debug=%h",
                         expected_data_out_1, expected_data_out_2, expected_data_out_3, expected_data_out_debug);
                $display("  Got:      data_out_1=%h, data_out_2=%h, data_out_3=%h, data_out_debug=%h",
                         data_out_1, data_out_2, data_out_3, data_out_debug);
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
        $dumpvars(0,WriteEnable, clock, clock_debug, read_address_1, read_address_2, read_address_3, read_address_debug, reset, write_address, write_data_in, data_out_1, data_out_2, data_out_3, data_out_debug);
    end

endmodule
