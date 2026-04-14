`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_signal;
    wire [9:0] output_lower;
    wire [21:0] output_upper;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_signal(input_signal),
        .output_lower(output_lower),
        .output_upper(output_upper)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            input_signal = 32'h0000_0000;
            #1;

            check_outputs(10'h000, 22'h00_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            input_signal = 32'hFFFF_FFFF;
            #1;

            check_outputs(10'h3FF, 22'h3F_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower Bits Boundary (Max Lower)", test_num);
            input_signal = 32'h0000_03FF;
            #1;

            check_outputs(10'h3FF, 22'h00_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Bits Boundary (Min Upper)", test_num);
            input_signal = 32'h0000_0400;
            #1;

            check_outputs(10'h000, 22'h00_0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern A", test_num);
            input_signal = 32'hAAAA_AAAA;



            #1;




            check_outputs(10'h2AA, 22'h2AAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Pattern 5", test_num);
            input_signal = 32'h5555_5555;



            #1;




            check_outputs(10'h155, 22'h155555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hex Pattern DEADBEEF", test_num);
            input_signal = 32'hDEAD_BEEF;



            #1;




            check_outputs(10'h2EF, 22'h37AB6F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Hex Pattern 12345678", test_num);
            input_signal = 32'h1234_5678;



            #1;




            check_outputs(10'h278, 22'h048D15);
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
        input [9:0] expected_output_lower;
        input [21:0] expected_output_upper;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_lower === (expected_output_lower ^ output_lower ^ expected_output_lower) &&
                expected_output_upper === (expected_output_upper ^ output_upper ^ expected_output_upper)) begin
                $display("PASS");
                $display("  Outputs: output_lower=%h, output_upper=%h",
                         output_lower, output_upper);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_lower=%h, output_upper=%h",
                         expected_output_lower, expected_output_upper);
                $display("  Got:      output_lower=%h, output_upper=%h",
                         output_lower, output_upper);
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
