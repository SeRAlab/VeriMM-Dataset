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
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying reset initialization (Reg[i] = i)", test_num);
            reset_dut();


            read_address_1 = 5;
            read_address_2 = 12;
            read_address_3 = 28;
            read_address_debug = 31;


            @(negedge clock);
            #2;

            #1;


            check_outputs(32'd5, 32'd12, 32'd28, 32'd31);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Register Write and Read", test_num);
            reset_dut();


            @(posedge clock);
            WriteEnable = 1;
            write_address = 7;
            write_data_in = 32'hDEADBEEF;

            @(posedge clock);
            WriteEnable = 0;


            read_address_1 = 7;
            read_address_2 = 0;
            read_address_3 = 1;
            read_address_debug = 7;

            @(negedge clock);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 32'd0, 32'd1, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Concurrent Multi-Port Reads", test_num);
            reset_dut();


            @(posedge clock);
            WriteEnable = 1;
            write_address = 10; write_data_in = 32'hAAAA0000; @(posedge clock);
            write_address = 11; write_data_in = 32'hBBBB1111; @(posedge clock);
            write_address = 12; write_data_in = 32'hCCCC2222; @(posedge clock);
            write_address = 13; write_data_in = 32'hDDDD3333; @(posedge clock);
            WriteEnable = 0;


            read_address_1 = 10;
            read_address_2 = 11;
            read_address_3 = 12;
            read_address_debug = 13;

            @(negedge clock);
            #2;

            #1;


            check_outputs(32'hAAAA0000, 32'hBBBB1111, 32'hCCCC2222, 32'hDDDD3333);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify WriteEnable (Disable)", test_num);
            reset_dut();


            @(posedge clock);
            WriteEnable = 0;
            write_address = 15;
            write_data_in = 32'hFFFFFFFF;

            @(posedge clock);


            read_address_1 = 15;
            read_address_2 = 15;
            read_address_3 = 15;
            read_address_debug = 15;

            @(negedge clock);
            #2;

            #1;


            check_outputs(32'd15, 32'd15, 32'd15, 32'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting existing data", test_num);
            reset_dut();


            @(posedge clock);
            WriteEnable = 1;
            write_address = 20;
            write_data_in = 32'h12345678;
            @(posedge clock);


            write_address = 20;
            write_data_in = 32'h87654321;
            @(posedge clock);
            WriteEnable = 0;

            read_address_1 = 20;
            read_address_2 = 20;
            read_address_3 = 20;
            read_address_debug = 20;

            @(negedge clock);
            #2;

            #1;


            check_outputs(32'h87654321, 32'h87654321, 32'h87654321, 32'h87654321);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary address check (0 and 31)", test_num);
            reset_dut();

            @(posedge clock);
            WriteEnable = 1;
            write_address = 0; write_data_in = 32'hF0F0F0F0; @(posedge clock);
            write_address = 31; write_data_in = 32'h0F0F0F0F; @(posedge clock);
            WriteEnable = 0;

            read_address_1 = 0;
            read_address_2 = 31;
            read_address_3 = 0;
            read_address_debug = 31;

            @(negedge clock);
            #2;

            #1;


            check_outputs(32'hF0F0F0F0, 32'h0F0F0F0F, 32'hF0F0F0F0, 32'h0F0F0F0F);
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
