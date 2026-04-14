`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_i;
    reg clk_i;
    reg [255:0] data_i;
    reg enable_i;
    reg rst_i;
    reg write_i;
    wire ack_o;
    wire [255:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .clk_i(clk_i),
        .data_i(data_i),
        .enable_i(enable_i),
        .rst_i(rst_i),
        .write_i(write_i),
        .ack_o(ack_o),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            addr_i = 0;
            data_i = 0;
            enable_i = 0;
            write_i = 0;
            @(posedge clk_i);
            #1;
            rst_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            $display("Testcase 001: Reset/Idle State");
            #1;

            check_outputs(1'b0, 256'h0);
        end
        endtask

    task testcase002;

        reg [255:0] test_data;
        begin
            test_num = 2;
            reset_dut();
            test_data = 256'hABCDEFFEDCBA0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;

            $display("Testcase 002: Basic Write and Read");


            @(posedge clk_i);
            enable_i = 1;
            write_i = 1;
            addr_i = 32'h0000_0004;
            data_i = test_data;
            @(posedge clk_i);
            #1;
            enable_i = 0;
            write_i = 0;


            @(posedge clk_i);
            enable_i = 1;
            write_i = 0;
            addr_i = 32'h0000_0004;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1, test_data);
        end
        endtask

    task testcase003;

        reg [255:0] data1;
        reg [255:0] data2;
        begin
            test_num = 3;
            reset_dut();
            data1 = 256'h1111_2222_3333_4444_5555_6666_7777_8888_9999_AAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000;
            data2 = 256'hAAAA_BBBB_CCCC_DDDD_EEEE_FFFF_0000_1111_2222_3333_4444_5555_6666_7777_8888_9999;

            $display("Testcase 003: Multi-address Write/Read");


            @(posedge clk_i);
            enable_i = 1; write_i = 1; addr_i = 32'h10; data_i = data1;
            @(posedge clk_i);

            enable_i = 1; write_i = 1; addr_i = 32'h20; data_i = data2;
            @(posedge clk_i);
            enable_i = 0;


            @(posedge clk_i);
            enable_i = 1; write_i = 0; addr_i = 32'h10;
            @(posedge clk_i);
            #1;
            if (data_o !== data1) begin
                $display("Sub-test Fail: Read 0x10 wrong");
            end


            @(posedge clk_i);
            enable_i = 1; write_i = 0; addr_i = 32'h20;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1, data2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Overwrite Memory Location");


            @(posedge clk_i);
            enable_i = 1; write_i = 1; addr_i = 32'hA0; data_i = 256'h1;
            @(posedge clk_i);

            enable_i = 1; write_i = 1; addr_i = 32'hA0; data_i = 256'h2;
            @(posedge clk_i);
            enable_i = 0;


            @(posedge clk_i);
            enable_i = 1; write_i = 0; addr_i = 32'hA0;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1, 256'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Enable Signal Logic");


            @(posedge clk_i);
            enable_i = 1; write_i = 1; addr_i = 32'hCC; data_i = 256'hFEED;
            @(posedge clk_i);


            enable_i = 0; write_i = 1; addr_i = 32'hCC; data_i = 256'hBEEF;
            @(posedge clk_i);


            enable_i = 1; write_i = 0; addr_i = 32'hCC;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1, 256'hFEED);
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
        input expected_ack_o;
        input [255:0] expected_data_o;
        begin
            if (expected_ack_o === (expected_ack_o ^ ack_o ^ expected_ack_o) &&
                expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: ack_o=%b, data_o=%h",
                         ack_o, data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_o=%b, data_o=%h",
                         expected_ack_o, expected_data_o);
                $display("  Got:      ack_o=%b, data_o=%h",
                         ack_o, data_o);
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
        $dumpvars(0,addr_i, clk_i, data_i, enable_i, rst_i, write_i, ack_o, data_o);
    end

endmodule
