`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] arr_in;
    wire [15:0] arr_out;

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
        test_num = test_num + 1;
        $display("Test %0d: Already Sorted", test_num);
        arr_in = 16'h4321;
        #1;

        check_outputs(16'h4321);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reverse Sorted", test_num);
        arr_in = 16'h1234;
        #1;

        check_outputs(16'h4321);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random Order", test_num);
        arr_in = 16'h2413;
        #1;

        check_outputs(16'h4321);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Identical", test_num);
        arr_in = 16'h7777;
        #1;

        check_outputs(16'h7777);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Two Pairs", test_num);
        arr_in = 16'h2828;
        #1;

        check_outputs(16'h8822);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Three of a Kind", test_num);
        arr_in = 16'h5955;
        #1;

        check_outputs(16'h9555);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero and Max", test_num);
        arr_in = 16'h0F0E;
        #1;

        check_outputs(16'hFE00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: One element out of order", test_num);
        arr_in = 16'h3215;
        #1;

        check_outputs(16'h5321);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum values", test_num);
        arr_in = 16'hFDCB;
        #1;

        check_outputs(16'hFEDC);

        arr_in = 16'hCDEF;
        #1;

        check_outputs(16'hFEDC);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum values", test_num);
        arr_in = 16'h1002;
        #1;

        check_outputs(16'h2100);
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
        input [15:0] expected_arr_out;
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
