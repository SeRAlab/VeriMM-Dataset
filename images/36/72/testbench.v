`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] arr_in;
    wire [19:0] arr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .arr_in(arr_in),
        .arr_out(arr_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Already sorted array", test_num);
            arr_in = 20'h12345;
            #1;

            check_outputs(20'h12345);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reverse sorted array", test_num);
            arr_in = 20'h54321;
            #1;

            check_outputs(20'h12345);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Random mixed values", test_num);
            arr_in = 20'hA1F30;
            #1;

            check_outputs(20'h013AF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Array with duplicates", test_num);
            arr_in = 20'h72725;
            #1;

            check_outputs(20'h22577);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Minimum and Maximum values", test_num);
            arr_in = 20'h0F0F0;
            #1;

            check_outputs(20'h000FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All elements identical", test_num);
            arr_in = 20'hAAAAA;
            #1;

            check_outputs(20'hAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Smallest element at the end", test_num);
            arr_in = 20'hFEDC0;
            #1;

            check_outputs(20'h0CDEF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Largest element at the beginning", test_num);
            arr_in = 20'hF1234;
            #1;

            check_outputs(20'h1234F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bubble_sort Testbench");
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
        input [19:0] expected_arr_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_arr_out === (expected_arr_out ^ arr_out ^ expected_arr_out)) begin
                $display("PASS");
                $display("  Outputs: arr_out=%h",
                         arr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: arr_out=%h",
                         expected_arr_out);
                $display("  Got:      arr_out=%h",
                         arr_out);
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
