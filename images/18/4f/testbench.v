`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] data_in;
    wire [19:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Already Sorted (Ascending)", test_num);
        data_in = 20'h12345;
        #1;

        check_outputs(20'h12345);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reverse Sorted (Descending)", test_num);
        data_in = 20'h54321;
        #1;

        check_outputs(20'h12345);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Elements Identical", test_num);
        data_in = 20'hAAAAA;
        #1;

        check_outputs(20'hAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Permutation 1", test_num);
        data_in = 20'h3A10F;
        #1;

        check_outputs(20'h013AF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Permutation 2 (With Duplicates)", test_num);
        data_in = 20'h72712;
        #1;

        check_outputs(20'h12277);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum and Maximum Values", test_num);
        data_in = 20'hF0F00;
        #1;

        check_outputs(20'h000FF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Values", test_num);
        data_in = 20'h1F1F1;
        #1;

        check_outputs(20'h111FF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Element Out of Place (Large at Start)", test_num);
        data_in = 20'hE1234;
        #1;

        check_outputs(20'h1234E);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single Element Out of Place (Small at End)", test_num);
        data_in = 20'hBCDE1;
        #1;

        check_outputs(20'h1BCDE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Unsigned Values", test_num);
        data_in = 20'hFEDC9;
        #1;

        check_outputs(20'h9CDEF);
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
        input [19:0] expected_data_out;
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
