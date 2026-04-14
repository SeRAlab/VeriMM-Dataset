`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctl_in;
    reg [63:0] data_in;
    wire ctl_out;
    wire [63:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctl_in(ctl_in),
        .data_in(data_in),
        .ctl_out(ctl_out),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: data_in[1]=0, non-zero data_in. Expect data_out=0", test_num);
            ctl_in = 1'b0;
            data_in = 64'hFEDCBA9876543210;
            #1;

            check_outputs(1'b0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: data_in[1]=1, expect data_out=data_in", test_num);
            ctl_in = 1'b0;
            data_in = 64'hFEDCBA9876543212;
            #1;

            check_outputs(1'b0, 64'hFEDCBA9876543212);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits high. Expect data_out=all 1s", test_num);
            ctl_in = 1'b1;
            data_in = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(1'b0, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit[1] low, others high. Expect data_out=0", test_num);
            ctl_in = 1'b1;
            data_in = 64'hFFFFFFFFFFFFFFFD;
            #1;

            check_outputs(1'b0, 64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only bit[1] high. Expect data_out=0x2", test_num);
            ctl_in = 1'b0;
            data_in = 64'h0000000000000002;
            #1;

            check_outputs(1'b0, 64'h0000000000000002);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pattern with bit[1]=0. Expect data_out=0", test_num);
            ctl_in = 1'b1;
            data_in = 64'hA5A5A5A5A5A5A5A5;
            #1;

            check_outputs(1'b0, 64'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify ctl_in isolation.", test_num);
            ctl_in = 1'b1;
            data_in = 64'h1234567887654322;
            #1;

            check_outputs(1'b0, 64'h1234567887654322);
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
        input expected_ctl_out;
        input [63:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ctl_out === (expected_ctl_out ^ ctl_out ^ expected_ctl_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ctl_out=%b, data_out=%h",
                         ctl_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ctl_out=%b, data_out=%h",
                         expected_ctl_out, expected_data_out);
                $display("  Got:      ctl_out=%b, data_out=%h",
                         ctl_out, data_out);
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
