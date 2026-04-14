`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg access_in;
    reg [3:0] ctrlmode_in;
    reg [31:0] data_in;
    reg [1:0] datamode_in;
    reg [31:0] dstaddr_in;
    reg [31:0] srcaddr_in;
    reg write_in;
    wire [103:0] packet_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .access_in(access_in),
        .ctrlmode_in(ctrlmode_in),
        .data_in(data_in),
        .datamode_in(datamode_in),
        .dstaddr_in(dstaddr_in),
        .srcaddr_in(srcaddr_in),
        .write_in(write_in),
        .packet_out(packet_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            access_in = 1'b0;
            write_in = 1'b0;
            datamode_in = 2'b00;
            ctrlmode_in = 4'b0000;
            dstaddr_in = 32'h00000000;
            data_in = 32'h00000000;
            srcaddr_in = 32'h00000000;
            #1;

            check_outputs(104'h00000000000000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            access_in = 1'b1;
            write_in = 1'b1;
            datamode_in = 2'b11;
            ctrlmode_in = 4'b1111;
            dstaddr_in = 32'hFFFFFFFF;
            data_in = 32'hFFFFFFFF;
            srcaddr_in = 32'hFFFFFFFF;

            #1;


            check_outputs(104'hFF_FFFFFFFF_FFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Pattern A", test_num);
            access_in = 1'b1;
            write_in = 1'b0;
            datamode_in = 2'b10;
            ctrlmode_in = 4'b1010;
            dstaddr_in = 32'h12345678;
            data_in = 32'h9ABCDEF0;
            srcaddr_in = 32'h5555AAAA;

            #1;


            check_outputs(104'hAA_12345678_9ABCDEF0_5555AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Pattern B", test_num);
            access_in = 1'b0;
            write_in = 1'b1;
            datamode_in = 2'b01;
            ctrlmode_in = 4'b0101;
            dstaddr_in = 32'hFEDCBA98;
            data_in = 32'h76543210;
            srcaddr_in = 32'hAAAA5555;

            #1;


            check_outputs(104'h55_FEDCBA98_76543210_AAAA5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Field Alignment", test_num);
            access_in = 1'b1;
            write_in = 1'b1;
            datamode_in = 2'b00;
            ctrlmode_in = 4'b0000;
            dstaddr_in = 32'hA0B0C0D0;
            data_in = 32'h11223344;
            srcaddr_in = 32'h66778899;

            #1;


            check_outputs(104'hC0_A0B0C0D0_11223344_66778899);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Check Low", test_num);
            access_in = 1'b0;
            write_in = 1'b0;
            datamode_in = 2'b00;
            ctrlmode_in = 4'b0001;
            dstaddr_in = 32'h00000000;
            data_in = 32'h00000000;
            srcaddr_in = 32'h00000001;

            #1;


            check_outputs(104'h01_00000000_00000000_00000001);
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
        input [103:0] expected_packet_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out)) begin
                $display("PASS");
                $display("  Outputs: packet_out=%h",
                         packet_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_out=%h",
                         expected_packet_out);
                $display("  Got:      packet_out=%h",
                         packet_out);
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
