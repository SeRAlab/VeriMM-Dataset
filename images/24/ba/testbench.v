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
            test_num = 1;
            $display("Test %0d: Already sorted input (1, 2, 3, 4)", test_num);
            data_in = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Reverse sorted input (4, 3, 2, 1)", test_num);
            data_in = 16'h4321;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: All identical values (7, 7, 7, 7)", test_num);
            data_in = 16'h7777;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Random order (3, 8, 2, A)", test_num);
            data_in = 16'h382A;
            #1;

            check_outputs(16'h238A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Duplicate values (5, 2, 5, 1)", test_num);
            data_in = 16'h5251;
            #1;

            check_outputs(16'h1255);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Max and Min hex values (F, 0, E, 1)", test_num);
            data_in = 16'hF0E1;
            #1;

            check_outputs(16'h01EF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Alternating extremes (0, F, 0, F)", test_num);
            data_in = 16'h0F0F;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Single large value at start (D, 2, 3, 4)", test_num);
            data_in = 16'hD234;
            #1;

            check_outputs(16'h234D);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Single small value at end (E, D, C, 0)", test_num);
            data_in = 16'hEDC0;
            #1;

            check_outputs(16'h0CDE);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Unsorted mixed values (9, 1, 5, 4)", test_num);
            data_in = 16'h9154;
            #1;

            check_outputs(16'h1459);
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
