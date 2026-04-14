`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in_data;
    reg in_enable;
    wire [3:0] out_data;
    wire out_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_data(in_data),
        .in_enable(in_enable),
        .out_data(out_data),
        .out_enable(out_enable)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Capture", test_num);

            in_enable = 0;
            in_data = 4'h0;
            #10;

            in_enable = 1;
            in_data = 4'hA;

            #1;


            check_outputs(4'hA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Holding (Disable Capture)", test_num);

            in_enable = 1;
            in_data = 4'h5;
            #10;

            in_enable = 0;
            in_data = 4'hF;

            #1;


            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Storage Independence", test_num);

            in_enable = 1;
            in_data = 4'h3;
            #10;
            in_enable = 0;
            #10;

            in_data = 4'hE;
            #5;
            in_data = 4'h7;
            #5;

            #1;


            check_outputs(4'h3, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All-Ones Pattern", test_num);

            in_enable = 0;
            in_data = 4'h0;
            #10;

            in_enable = 1;
            in_data = 4'hF;
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Enable Sequence", test_num);

            in_enable = 1; in_data = 4'h1; #10;

            in_enable = 0; in_data = 4'h2; #10;

            in_enable = 1; in_data = 4'hC; #10;

            in_enable = 0;

            #1;


            check_outputs(4'hC, 1'b0);
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
        input [3:0] expected_out_data;
        input expected_out_enable;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_enable === (expected_out_enable ^ out_enable ^ expected_out_enable)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h, out_enable=%b",
                         out_data, out_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h, out_enable=%b",
                         expected_out_data, expected_out_enable);
                $display("  Got:      out_data=%h, out_enable=%b",
                         out_data, out_enable);
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
