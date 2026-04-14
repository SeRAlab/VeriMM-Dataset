`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dst_ip;
    reg [7:0] protocol;
    reg [31:0] src_ip;
    wire action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dst_ip(dst_ip),
        .protocol(protocol),
        .src_ip(src_ip),
        .action(action)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Exact Match (Expected: Accept)");
            src_ip   = 32'hC0A80101;
            dst_ip   = 32'h0A000001;
            protocol = 8'h06;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Incorrect Source IP (Expected: Reject)");
            src_ip   = 32'hFFFFFFFF;
            dst_ip   = 32'h0A000001;
            protocol = 8'h06;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Incorrect Destination IP (Expected: Reject)");
            src_ip   = 32'hC0A80101;
            dst_ip   = 32'hC0A80105;
            protocol = 8'h06;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Incorrect Protocol (Expected: Reject)");
            src_ip   = 32'hC0A80101;
            dst_ip   = 32'h0A000001;
            protocol = 8'h11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: All Inputs Zero (Expected: Reject)");
            src_ip   = 32'h00000000;
            dst_ip   = 32'h00000000;
            protocol = 8'h00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Boundary Input Check (Expected: Reject)");
            src_ip   = 32'hC0A80100;
            dst_ip   = 32'h0A000001;
            protocol = 8'h06;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Multiple Field Mismatch (Expected: Reject)");
            src_ip   = 32'hDEADBEEF;
            dst_ip   = 32'h0000CAFE;
            protocol = 8'h01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_action;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_action === (expected_action ^ action ^ expected_action)) begin
                $display("PASS");
                $display("  Outputs: action=%b",
                         action);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: action=%b",
                         expected_action);
                $display("  Got:      action=%b",
                         action);
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
