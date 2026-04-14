`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [103:0] packet_in;
    wire access_out;
    wire [3:0] ctrlmode_out;
    wire [31:0] data_out;
    wire [1:0] datamode_out;
    wire [31:0] dstaddr_out;
    wire [31:0] srcaddr_out;
    wire write_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .packet_in(packet_in),
        .access_out(access_out),
        .ctrlmode_out(ctrlmode_out),
        .data_out(data_out),
        .datamode_out(datamode_out),
        .dstaddr_out(dstaddr_out),
        .srcaddr_out(srcaddr_out),
        .write_out(write_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros", test_num);
            packet_in = 104'h0;

            #1;


            check_outputs(1'b0, 4'h0, 32'h0, 2'b00, 32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: All Ones", test_num);
            packet_in = {104{1'b1}};

            #1;


            check_outputs(1'b1, 4'hF, 32'hFFFFFFFF, 2'b11, 32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Standard Read Packet", test_num);

            packet_in = {1'b1, 1'b0, 2'b10, 4'hA, 32'hDEADBEEF, 32'hCAFEBABE, 32'h12345678};
            #1;

            check_outputs(1'b1, 4'hA, 32'h12345678, 2'b10, 32'hDEADBEEF, 32'hCAFEBABE, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Standard Write Packet", test_num);

            packet_in = {1'b0, 1'b1, 2'b01, 4'h5, 32'h88887777, 32'h66665555, 32'hAAAA4444};
            #1;

            check_outputs(1'b0, 4'h5, 32'hAAAA4444, 2'b01, 32'h88887777, 32'h66665555, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating Bits", test_num);
            packet_in = 104'hAAAAAAAAAAAAAAAAAAAAAAAAAA;


            #1;



            check_outputs(1'b1, 4'hA, 32'hAAAAAAAA, 2'b10, 32'hAAAAAAAA, 32'hAAAAAAAA, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Inverse Alternating Bits", test_num);
            packet_in = 104'h55555555555555555555555555;


            #1;



            check_outputs(1'b0, 4'h5, 32'h55555555, 2'b01, 32'h55555555, 32'h55555555, 1'b1);
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
        input expected_access_out;
        input [3:0] expected_ctrlmode_out;
        input [31:0] expected_data_out;
        input [1:0] expected_datamode_out;
        input [31:0] expected_dstaddr_out;
        input [31:0] expected_srcaddr_out;
        input expected_write_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_access_out === (expected_access_out ^ access_out ^ expected_access_out) &&
                expected_ctrlmode_out === (expected_ctrlmode_out ^ ctrlmode_out ^ expected_ctrlmode_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_datamode_out === (expected_datamode_out ^ datamode_out ^ expected_datamode_out) &&
                expected_dstaddr_out === (expected_dstaddr_out ^ dstaddr_out ^ expected_dstaddr_out) &&
                expected_srcaddr_out === (expected_srcaddr_out ^ srcaddr_out ^ expected_srcaddr_out) &&
                expected_write_out === (expected_write_out ^ write_out ^ expected_write_out)) begin
                $display("PASS");
                $display("  Outputs: access_out=%b, ctrlmode_out=%h, data_out=%h, datamode_out=%h, dstaddr_out=%h, srcaddr_out=%h, write_out=%b",
                         access_out, ctrlmode_out, data_out, datamode_out, dstaddr_out, srcaddr_out, write_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: access_out=%b, ctrlmode_out=%h, data_out=%h, datamode_out=%h, dstaddr_out=%h, srcaddr_out=%h, write_out=%b",
                         expected_access_out, expected_ctrlmode_out, expected_data_out, expected_datamode_out, expected_dstaddr_out, expected_srcaddr_out, expected_write_out);
                $display("  Got:      access_out=%b, ctrlmode_out=%h, data_out=%h, datamode_out=%h, dstaddr_out=%h, srcaddr_out=%h, write_out=%b",
                         access_out, ctrlmode_out, data_out, datamode_out, dstaddr_out, srcaddr_out, write_out);
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
