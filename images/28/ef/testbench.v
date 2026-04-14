`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] data_in;
    wire [19:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Already sorted input", test_num);
        data_in = 20'h12345;
        #1;

        check_outputs(20'h12345);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Reverse sorted input", test_num);
        data_in = 20'h54321;
        #1;

        check_outputs(20'h12345);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Random distribution", test_num);
        data_in = 20'hA2F70;
        #1;

        check_outputs(20'h027AF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All identical values", test_num);
        data_in = 20'h77777;
        #1;

        check_outputs(20'h77777);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Multiple duplicate values", test_num);
        data_in = 20'h14141;
        #1;

        check_outputs(20'h11144);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Minimum and Maximum values", test_num);
        data_in = 20'hF0F08;
        #1;

        check_outputs(20'h008FF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Only one value out of place", test_num);
        data_in = 20'h23145;
        #1;

        check_outputs(20'h12345);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: High-range values", test_num);
        data_in = 20'hBDECF;
        #1;

        check_outputs(20'hBCDEF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Single non-zero element", test_num);
        data_in = 20'h00050;
        #1;

        check_outputs(20'h00005);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Descending hex sequence", test_num);
        data_in = 20'h98765;
        #1;

        check_outputs(20'h56789);
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
