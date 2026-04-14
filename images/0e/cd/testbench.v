`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [15:0] data_out;

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
        test_num = test_num + 1;
        $display("Test %0d: Already sorted ascending (1, 2, 3, 4)", test_num);
        data_in = 16'h4321;
        #1;

        check_outputs(16'h4321);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reverse sorted (4, 3, 2, 1)", test_num);
        data_in = 16'h1234;
        #1;

        check_outputs(16'h4321);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random distribution (10, 5, 2, 11)", test_num);
        data_in = 16'hA52B;
        #1;

        check_outputs(16'hBA52);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random distribution (3, 15, 8, 1)", test_num);
        data_in = 16'h3F81;
        #1;

        check_outputs(16'hF831);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All elements equal (7, 7, 7, 7)", test_num);
        data_in = 16'h7777;
        #1;

        check_outputs(16'h7777);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Duplicates (2, 9, 2, 9)", test_num);
        data_in = 16'h2929;
        #1;

        check_outputs(16'h9922);
    end
    endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Min and Max values (0, 15, 0, 15)", test_num);
        data_in = 16'h0F0F;
        #1;

        check_outputs(16'hFF00);
    end
    endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Already sorted large values (12, 13, 14, 15)", test_num);
        data_in = 16'hFEDC;
        #1;

        check_outputs(16'hFEDC);
    end
    endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reverse sorted large values (15, 14, 13, 12)", test_num);
        data_in = 16'hCDEF;
        #1;

        check_outputs(16'hFEDC);
    end
    endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed zeros and small values (0, 2, 0, 1)", test_num);
        data_in = 16'h0201;
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
