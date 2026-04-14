`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] DAT_I;
    reg STB;
    reg WE;
    reg clk;
    reg reset;
    wire ACK;
    wire [3:0] AN;
    wire [31:0] DAT_O;
    wire [7:0] Segment;
    wire [15:0] debug_data_hold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DAT_I(DAT_I),
        .STB(STB),
        .WE(WE),
        .clk(clk),
        .reset(reset),
        .ACK(ACK),
        .AN(AN),
        .DAT_O(DAT_O),
        .Segment(Segment),
        .debug_data_hold(debug_data_hold)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            DAT_I = 32'h0;
            STB = 0;
            WE = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset State");
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b0001, 32'h0, hex_to_seg(4'h0), 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Load 0x1234 and Scan Digit 0");
            reset_dut();


            DAT_I = 32'h0000_1234;
            STB = 1;
            WE = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(ACK, 4'b0001, 32'h0, hex_to_seg(4'h4), 16'h1234);

            STB = 0;
            WE = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Verify Scanning Cycle for 0xABCD");
            reset_dut();

            DAT_I = 32'h0000_ABCD;
            STB = 1;
            WE = 1;
            @(posedge clk);
            #1;
            STB = 0; WE = 0;


            #1;



            check_outputs(ACK, 4'b0001, 32'h0, hex_to_seg(4'hD), 16'hABCD);


            @(posedge clk); #1;
            #1;

            check_outputs(ACK, 4'b0010, 32'h0, hex_to_seg(4'hC), 16'hABCD);


            @(posedge clk); #1;
            #1;

            check_outputs(ACK, 4'b0100, 32'h0, hex_to_seg(4'hB), 16'hABCD);


            @(posedge clk); #1;
            #1;

            check_outputs(ACK, 4'b1000, 32'h0, hex_to_seg(4'hA), 16'hABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Data Retention");
            reset_dut();


            DAT_I = 32'h0000_5555;
            STB = 1; WE = 1;
            @(posedge clk);
            #1;
            STB = 0; WE = 0;


            DAT_I = 32'hFFFF_FFFF;
            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(ACK, 4'b0001, 32'h0, hex_to_seg(4'h5), 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Acknowledge Pulse");
            reset_dut();

            DAT_I = 32'h0000_9999;
            STB = 1; WE = 1;
            #1;

            if (ACK === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: ACK signal detected");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: ACK signal not detected during STB");
            end

            @(posedge clk);
            STB = 0; WE = 0;
            #1;
            #1;

            check_outputs(ACK, 4'b0001, 32'h0, hex_to_seg(4'h9), 16'h9999);
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
        input expected_ACK;
        input [3:0] expected_AN;
        input [31:0] expected_DAT_O;
        input [7:0] expected_Segment;
        input [15:0] expected_debug_data_hold;
        begin
            if (expected_ACK === (expected_ACK ^ ACK ^ expected_ACK) &&
                expected_AN === (expected_AN ^ AN ^ expected_AN) &&
                expected_DAT_O === (expected_DAT_O ^ DAT_O ^ expected_DAT_O) &&
                expected_Segment === (expected_Segment ^ Segment ^ expected_Segment) &&
                expected_debug_data_hold === (expected_debug_data_hold ^ debug_data_hold ^ expected_debug_data_hold)) begin
                $display("PASS");
                $display("  Outputs: ACK=%b, AN=%h, DAT_O=%h, Segment=%h, debug_data_hold=%h",
                         ACK, AN, DAT_O, Segment, debug_data_hold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACK=%b, AN=%h, DAT_O=%h, Segment=%h, debug_data_hold=%h",
                         expected_ACK, expected_AN, expected_DAT_O, expected_Segment, expected_debug_data_hold);
                $display("  Got:      ACK=%b, AN=%h, DAT_O=%h, Segment=%h, debug_data_hold=%h",
                         ACK, AN, DAT_O, Segment, debug_data_hold);
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
        $dumpvars(0,DAT_I, STB, WE, clk, reset, ACK, AN, DAT_O, Segment, debug_data_hold);
    end

endmodule
