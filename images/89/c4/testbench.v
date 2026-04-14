`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg enable;
    reg [15:0] mask;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .enable(enable),
        .mask(mask),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Enable low - Output should match data_in (Bypass mode)", test_num);
            enable = 1'b0;
            data_in = 16'hA5A5;
            mask = 16'h00FF;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Enable high - Bitwise AND with all-ones mask", test_num);
            enable = 1'b1;
            data_in = 16'h1234;
            mask = 16'hFFFF;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Enable high - Bitwise AND with all-zeros mask", test_num);
            enable = 1'b1;
            data_in = 16'hFFFF;
            mask = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Enable high - Selective nibble masking", test_num);
            enable = 1'b1;
            data_in = 16'hF0F0;
            mask = 16'hAAAA;


            #1;



            check_outputs(16'hA0A0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Enable low - Verify mask is ignored even if non-zero", test_num);
            enable = 1'b0;
            data_in = 16'hFFFF;
            mask = 16'h5555;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Enable high - Alternating bit mask", test_num);
            enable = 1'b1;
            data_in = 16'h3333;
            mask = 16'h5555;

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Enable high - Masking top and bottom bytes", test_num);
            enable = 1'b1;
            data_in = 16'h1234;
            mask = 16'hFF00;
            #1;

            check_outputs(16'h1200);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Enable high - Data with zeros and random mask", test_num);
            enable = 1'b1;
            data_in = 16'h0000;
            mask = 16'hABCD;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
