`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] x;
    reg [7:0] y;
    wire [16:0] mem_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .mem_address(mem_address)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 9'd0;
            y = 8'd0;
            #1;

            check_outputs(17'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 9'd319;
            y = 8'd0;
            #1;

            check_outputs(17'd319);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 9'd0;
            y = 8'd1;
            #1;

            check_outputs(17'd320);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 9'd160;
            y = 8'd120;
            #1;

            check_outputs(17'd38560);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 9'd319;
            y = 8'd239;
            #1;

            check_outputs(17'd76799);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 9'd10;
            y = 8'd10;
            #1;

            check_outputs(17'd3210);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 9'd319;
            y = 8'd100;
            #1;

            check_outputs(17'd32319);
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
        input [16:0] expected_mem_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_address === (expected_mem_address ^ mem_address ^ expected_mem_address)) begin
                $display("PASS");
                $display("  Outputs: mem_address=%h",
                         mem_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_address=%h",
                         expected_mem_address);
                $display("  Got:      mem_address=%h",
                         mem_address);
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
