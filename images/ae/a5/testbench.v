`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg access_in;
    reg clk1;
    reg clk2;
    reg nreset;
    reg [103:0] packet_in;
    reg vdd;
    reg vss;
    reg wait_in;
    wire access_out;
    wire clkout;
    wire dut_active;
    wire [103:0] packet_out;
    wire wait_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .access_in(access_in),
        .clk1(clk1),
        .clk2(clk2),
        .nreset(nreset),
        .packet_in(packet_in),
        .vdd(vdd),
        .vss(vss),
        .wait_in(wait_in),
        .access_out(access_out),
        .clkout(clkout),
        .dut_active(dut_active),
        .packet_out(packet_out),
        .wait_out(wait_out)
    );
    task cycle_clocks;

        input integer counts;
        integer i;
        begin
            for (i = 0; i < counts; i = i + 1) begin
                @(posedge clk1);
            end
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: System Reset");
            nreset = 0;
            access_in = 0;
            packet_in = 0;
            wait_in = 0;
            vdd = 1;
            vss = 0;
            cycle_clocks(5);


            #1;



            check_outputs(0, 0, 0, 104'h0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Zero Data Transfer");
            nreset = 0; cycle_clocks(2); nreset = 1; cycle_clocks(2);

            access_in = 1;
            packet_in = 104'h0;
            wait_in = 0;
            cycle_clocks(10);


            #1;



            check_outputs(1, 1, 1, 104'h0, 0);
        end
        endtask

    task testcase003;

        reg [103:0] expected_gray;
        begin
            $display("Testcase 003: Data Transformation Pattern A");
            nreset = 0; cycle_clocks(2); nreset = 1; cycle_clocks(2);

            packet_in = 104'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FF;
            expected_gray = bin2gray(packet_in);
            access_in = 1;
            cycle_clocks(10);




            #1;





            check_outputs(1, 1, 1, expected_gray, 0);
        end
        endtask

    task testcase004;

        reg [103:0] expected_gray;
        begin
            $display("Testcase 004: Data Transformation Pattern B");
            nreset = 0; cycle_clocks(2); nreset = 1; cycle_clocks(2);

            packet_in = 104'hAAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AA;
            expected_gray = bin2gray(packet_in);
            access_in = 1;
            cycle_clocks(10);

            #1;


            check_outputs(1, 1, 1, expected_gray, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Wait Signal Handshake");
            nreset = 0; cycle_clocks(2); nreset = 1; cycle_clocks(2);

            access_in = 1;
            packet_in = 104'h1234_5678_9ABC_DEF0_1234_5678_9A;
            wait_in = 1;
            cycle_clocks(5);



            #1;




            check_outputs(1, 1, 1, bin2gray(packet_in), 1);
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
        input expected_access_out;
        input expected_clkout;
        input expected_dut_active;
        input [103:0] expected_packet_out;
        input expected_wait_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_access_out === (expected_access_out ^ access_out ^ expected_access_out) &&
                expected_clkout === (expected_clkout ^ clkout ^ expected_clkout) &&
                expected_dut_active === (expected_dut_active ^ dut_active ^ expected_dut_active) &&
                expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_wait_out === (expected_wait_out ^ wait_out ^ expected_wait_out)) begin
                $display("PASS");
                $display("  Outputs: access_out=%b, clkout=%b, dut_active=%b, packet_out=%h, wait_out=%b",
                         access_out, clkout, dut_active, packet_out, wait_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: access_out=%b, clkout=%b, dut_active=%b, packet_out=%h, wait_out=%b",
                         expected_access_out, expected_clkout, expected_dut_active, expected_packet_out, expected_wait_out);
                $display("  Got:      access_out=%b, clkout=%b, dut_active=%b, packet_out=%h, wait_out=%b",
                         access_out, clkout, dut_active, packet_out, wait_out);
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

endmodule
