`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] d_i;
    reg [3:0] shift_i;
    wire [47:0] shifted_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d_i(d_i),
        .shift_i(shift_i),
        .shifted_o(shifted_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 0 bytes", test_num);
            d_i = 24'hABCDEF;
            shift_i = 4'd0;
            #1;

            check_outputs(48'h000000ABCDEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 1 byte", test_num);
            d_i = 24'hABCDEF;
            shift_i = 4'd1;
            #1;

            check_outputs(48'h0000ABCDEF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 2 bytes", test_num);
            d_i = 24'hABCDEF;
            shift_i = 4'd2;
            #1;

            check_outputs(48'h00ABCDEF0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 3 bytes", test_num);
            d_i = 24'hABCDEF;
            shift_i = 4'd3;
            #1;

            check_outputs(48'hABCDEF000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 4 bytes (Partial loss)", test_num);
            d_i = 24'h112233;
            shift_i = 4'd4;

            #1;


            check_outputs(48'h223300000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 5 bytes (Partial loss)", test_num);
            d_i = 24'h112233;
            shift_i = 4'd5;

            #1;


            check_outputs(48'h330000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones shift", test_num);
            d_i = 24'hFFFFFF;
            shift_i = 4'd2;
            #1;

            check_outputs(48'h00FFFFFF0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero input", test_num);
            d_i = 24'h000000;
            shift_i = 4'd1;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overshift (All data out)", test_num);
            d_i = 24'hABCDEF;
            shift_i = 4'd6;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max shift register value (15)", test_num);
            d_i = 24'hFFFFFF;
            shift_i = 4'd15;
            #1;

            check_outputs(48'h000000000000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [47:0] expected_shifted_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shifted_o === (expected_shifted_o ^ shifted_o ^ expected_shifted_o)) begin
                $display("PASS");
                $display("  Outputs: shifted_o=%h",
                         shifted_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_o=%h",
                         expected_shifted_o);
                $display("  Got:      shifted_o=%h",
                         shifted_o);
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
