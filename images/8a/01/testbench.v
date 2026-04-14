`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] cpx_io_grant_ca;
    reg [7:0] io_cpx_req_cq;
    wire [7:0] cpx_io_grant_bufio_ca;
    wire [7:0] io_cpx_req_bufio_cq_l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cpx_io_grant_ca(cpx_io_grant_ca),
        .io_cpx_req_cq(io_cpx_req_cq),
        .cpx_io_grant_bufio_ca(cpx_io_grant_bufio_ca),
        .io_cpx_req_bufio_cq_l(io_cpx_req_bufio_cq_l)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: All zeros input", test_num);
            cpx_io_grant_ca = 8'h00;
            io_cpx_req_cq = 8'h00;
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All ones input", test_num);
            cpx_io_grant_ca = 8'hFF;
            io_cpx_req_cq = 8'hFF;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checkerboard pattern A", test_num);
            cpx_io_grant_ca = 8'hAA;
            io_cpx_req_cq = 8'h55;
            #1;

            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checkerboard pattern B", test_num);
            cpx_io_grant_ca = 8'h55;
            io_cpx_req_cq = 8'hAA;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Nibble swap test", test_num);
            cpx_io_grant_ca = 8'h0F;
            io_cpx_req_cq = 8'hF0;
            #1;

            check_outputs(8'h0F, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Arbitrary data test", test_num);
            cpx_io_grant_ca = 8'h12;
            io_cpx_req_cq = 8'hED;
            #1;

            check_outputs(8'h12, 8'h12);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Walking bit test", test_num);
            cpx_io_grant_ca = 8'h80;
            io_cpx_req_cq = 8'h01;
            #1;

            check_outputs(8'h80, 8'hFE);
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
        testcase007();
        
        
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
        input [7:0] expected_cpx_io_grant_bufio_ca;
        input [7:0] expected_io_cpx_req_bufio_cq_l;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cpx_io_grant_bufio_ca === (expected_cpx_io_grant_bufio_ca ^ cpx_io_grant_bufio_ca ^ expected_cpx_io_grant_bufio_ca) &&
                expected_io_cpx_req_bufio_cq_l === (expected_io_cpx_req_bufio_cq_l ^ io_cpx_req_bufio_cq_l ^ expected_io_cpx_req_bufio_cq_l)) begin
                $display("PASS");
                $display("  Outputs: cpx_io_grant_bufio_ca=%h, io_cpx_req_bufio_cq_l=%h",
                         cpx_io_grant_bufio_ca, io_cpx_req_bufio_cq_l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpx_io_grant_bufio_ca=%h, io_cpx_req_bufio_cq_l=%h",
                         expected_cpx_io_grant_bufio_ca, expected_io_cpx_req_bufio_cq_l);
                $display("  Got:      cpx_io_grant_bufio_ca=%h, io_cpx_req_bufio_cq_l=%h",
                         cpx_io_grant_bufio_ca, io_cpx_req_bufio_cq_l);
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
