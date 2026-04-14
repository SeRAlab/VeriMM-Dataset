`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] address;
    reg [1023:0] input0;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .input0(input0),
        .out(out)
    );
    task testcase001;

        begin
            $display("\nRunning testcase001: Selecting Index 0");
            test_num = test_num + 1;
            input0 = {1024{1'b0}};
            input0[31:0] = 32'hAAAA_5555;
            address = 5'd0;
            #1;

            check_outputs(32'hAAAA_5555);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Selecting Index 31 (Highest)");
            test_num = test_num + 1;
            input0 = {1024{1'b0}};
            input0[1023:992] = 32'h1234_5678;
            address = 5'd31;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Mid-range Index 15");
            test_num = test_num + 1;
            input0 = {1024{1'b1}};
            input0[15*32 +: 32] = 32'hDEAD_BEEF;
            address = 5'd15;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: All Zeros across all buses");
            test_num = test_num + 1;
            input0 = 1024'b0;
            address = 5'd7;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: All Ones across all buses");
            test_num = test_num + 1;
            input0 = {32{32'hFFFF_FFFF}};
            address = 5'd24;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        integer i;
        reg [31:0] expected_val;
        begin
            $display("\nRunning testcase006: Exhaustive address sweep");

            for (i = 0; i < 32; i = i + 1) begin
                input0[i*32 +: 32] = (32'hC0DE_0000 | i);
            end


            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                address = i[4:0];
                expected_val = (32'hC0DE_0000 | i);
                #1;

                check_outputs(expected_val);
            end
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Walking Bit Pattern");
            test_num = test_num + 1;
            input0 = 1024'b0;
            input0[10*32 +: 32] = 32'h0000_0001;
            address = 5'd10;
            #1;

            check_outputs(32'h0000_0001);

            test_num = test_num + 1;
            input0[10*32 +: 32] = 32'h8000_0000;
            #1;

            check_outputs(32'h8000_0000);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
