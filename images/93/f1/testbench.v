`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg [127:0] out_data;
    reg read;
    wire [127:0] data;
    wire [31:0] out_address;
    wire out_read;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .out_data(out_data),
        .read(read),
        .data(data),
        .out_address(out_address),
        .out_read(out_read)
    );

    // Clock generation (10ns period)
    initial begin
        read = 0;
        forever #5 read = ~read;
    end

        task reset_dut;

        begin
            address = 32'h0;
            out_data = 128'h0;

            repeat(100) @(posedge read);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cold Miss and subsequent Hit", test_num);
            reset_dut();


            address = 32'h0000_1000;
            out_data = 128'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111;
            @(posedge read); #1;
            @(posedge read); #1;


            address = 32'h0000_1000;
            @(posedge read); #1;

            #1;


            check_outputs(128'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111, 32'h0000_1000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Accessing different Cache Indices", test_num);
            reset_dut();


            address = 32'h0000_1010;
            out_data = 128'h1111_1111_2222_2222_3333_3333_4444_4444;
            repeat(2) @(posedge read); #1;


            address = 32'h0000_1010;
            @(posedge read); #1;

            #1;


            check_outputs(128'h1111_1111_2222_2222_3333_3333_4444_4444, 32'h0000_1010, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Tag Conflict (Index 0 Overwrite)", test_num);
            reset_dut();


            address = 32'h0000_1000;
            out_data = 128'hFEED_FACE_CAFE_BABE_DEAD_BEEF_0000_0000;
            repeat(2) @(posedge read); #1;


            address = 32'h0000_1400;
            out_data = 128'h0000_0000_1111_1111_2222_2222_3333_3333;
            repeat(2) @(posedge read); #1;


            address = 32'h0000_1400;
            @(posedge read); #1;

            #1;


            check_outputs(128'h0000_0000_1111_1111_2222_2222_3333_3333, 32'h0000_1400, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Index Independence Verification", test_num);
            reset_dut();


            address = 32'h0000_1020;
            out_data = 128'h5555_5555_AAAA_AAAA_5555_5555_AAAA_AAAA;
            repeat(2) @(posedge read); #1;


            address = 32'h0000_1000;
            out_data = 128'h0;
            repeat(2) @(posedge read); #1;
            address = 32'h0000_1400;
            out_data = 128'hFFFF_FFFF;
            repeat(2) @(posedge read); #1;


            address = 32'h0000_1020;
            @(posedge read); #1;

            #1;


            check_outputs(128'h5555_5555_AAAA_AAAA_5555_5555_AAAA_AAAA, 32'h0000_1020, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Address Tag Verification", test_num);
            reset_dut();

            address = 32'hFFFF_F000;
            out_data = 128'h8888_7777_6666_5555_4444_3333_2222_1111;
            repeat(2) @(posedge read); #1;

            address = 32'hFFFF_F000;
            @(posedge read); #1;

            #1;


            check_outputs(128'h8888_7777_6666_5555_4444_3333_2222_1111, 32'hFFFF_F000, 1'b0);
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
        input [127:0] expected_data;
        input [31:0] expected_out_address;
        input expected_out_read;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data) &&
                expected_out_address === (expected_out_address ^ out_address ^ expected_out_address) &&
                expected_out_read === (expected_out_read ^ out_read ^ expected_out_read)) begin
                $display("PASS");
                $display("  Outputs: data=%h, out_address=%h, out_read=%b",
                         data, out_address, out_read);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h, out_address=%h, out_read=%b",
                         expected_data, expected_out_address, expected_out_read);
                $display("  Got:      data=%h, out_address=%h, out_read=%b",
                         data, out_address, out_read);
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
        $dumpvars(0,address, out_data, read, data, out_address, out_read);
    end

endmodule
