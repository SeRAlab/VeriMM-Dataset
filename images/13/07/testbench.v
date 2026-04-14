`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] array_in;
    wire [31:0] array_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .array_in(array_in),
        .array_out(array_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Random Unsorted Sequence", test_num);
            array_in = 32'h5281A3C4;
            #1;

            check_outputs(32'h123458AC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Already Sorted Sequence", test_num);
            array_in = 32'h01234567;
            #1;

            check_outputs(32'h01234567);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Reverse Sorted Sequence", test_num);
            array_in = 32'hFEDCBA98;
            #1;

            check_outputs(32'h89ABCDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: All Identical Elements", test_num);
            array_in = 32'h77777777;
            #1;

            check_outputs(32'h77777777);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Min and Max values", test_num);
            array_in = 32'hF0F0F0F0;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiple Duplicates", test_num);
            array_in = 32'h15152626;
            #1;

            check_outputs(32'h11225566);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Start element out of place", test_num);
            array_in = 32'hF1234567;
            #1;

            check_outputs(32'h1234567F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: End element out of place", test_num);
            array_in = 32'h89ABCDE0;
            #1;

            check_outputs(32'h089ABCDE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort Testbench");
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
        input [31:0] expected_array_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_array_out === (expected_array_out ^ array_out ^ expected_array_out)) begin
                $display("PASS");
                $display("  Outputs: array_out=%h",
                         array_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: array_out=%h",
                         expected_array_out);
                $display("  Got:      array_out=%h",
                         array_out);
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
