`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] sdma_req_i;
    reg [3:0] sdma_sreq_i;
    wire [3:0] sdma_active_o;
    wire [3:0] sdma_done_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sdma_req_i(sdma_req_i),
        .sdma_sreq_i(sdma_sreq_i),
        .sdma_active_o(sdma_active_o),
        .sdma_done_o(sdma_done_o)
    );
    task testcase001;

        begin
            $display("Testcase 001: Initialization / All signals zero");
            test_num = 1;

            sdma_req_i = 4'b0000;
            sdma_sreq_i = 4'b0000;

            #1;


            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single DMA request active");
            test_num = 2;
            sdma_req_i = 4'b0000;
            sdma_sreq_i = 4'b0000;
            #5;
            sdma_req_i = 4'b0001;
            #1;

            check_outputs(4'b0001, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single DMA sub-request completion");
            test_num = 3;
            sdma_req_i = 4'b0000;
            sdma_sreq_i = 4'b0000;
            #5;
            sdma_sreq_i = 4'b0010;
            #1;

            check_outputs(4'b0000, 4'b0010);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simultaneous request and sub-request");
            test_num = 4;
            sdma_req_i = 4'b0000;
            sdma_sreq_i = 4'b0000;
            #5;
            sdma_req_i = 4'b1000;
            sdma_sreq_i = 4'b1000;
            #1;

            check_outputs(4'b1000, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple simultaneous requests");
            test_num = 5;
            sdma_req_i = 4'b0000;
            sdma_sreq_i = 4'b0000;
            #5;
            sdma_req_i = 4'b0101;
            sdma_sreq_i = 4'b1010;
            #1;

            check_outputs(4'b0101, 4'b1010);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Full bandwidth (all bits active)");
            test_num = 6;
            sdma_req_i = 4'b0000;
            sdma_sreq_i = 4'b0000;
            #5;
            sdma_req_i = 4'b1111;
            sdma_sreq_i = 4'b1111;
            #1;

            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Overlapping sequence check");
            test_num = 7;
            sdma_req_i = 4'b0000;
            sdma_sreq_i = 4'b0000;
            #5;
            sdma_req_i = 4'b0011;
            #5;
            sdma_sreq_i = 4'b0001;
            #1;

            check_outputs(4'b0011, 4'b0001);
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
        input [3:0] expected_sdma_active_o;
        input [3:0] expected_sdma_done_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sdma_active_o === (expected_sdma_active_o ^ sdma_active_o ^ expected_sdma_active_o) &&
                expected_sdma_done_o === (expected_sdma_done_o ^ sdma_done_o ^ expected_sdma_done_o)) begin
                $display("PASS");
                $display("  Outputs: sdma_active_o=%h, sdma_done_o=%h",
                         sdma_active_o, sdma_done_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sdma_active_o=%h, sdma_done_o=%h",
                         expected_sdma_active_o, expected_sdma_done_o);
                $display("  Got:      sdma_active_o=%h, sdma_done_o=%h",
                         sdma_active_o, sdma_done_o);
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
