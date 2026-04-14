`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [15:0] data_out;

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
            $display("Test Case 001: Random sequence");
            test_num = 1;
            data_in = 16'h3142;

            #1;


            check_outputs(16'h4321);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Reverse sorted sequence");
            test_num = 2;
            data_in = 16'h1234;

            #1;


            check_outputs(16'h4321);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Already sorted sequence");
            test_num = 3;
            data_in = 16'h4321;

            #1;


            check_outputs(16'h4321);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: All identical elements");
            test_num = 4;
            data_in = 16'h7777;

            #1;


            check_outputs(16'h7777);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Mixed elements with zeros");
            test_num = 5;
            data_in = 16'h0502;

            #1;


            check_outputs(16'h5200);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Mixed elements with max value (F)");
            test_num = 6;
            data_in = 16'hF5A1;

            #1;


            check_outputs(16'hFA51);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Sequence with duplicates");
            test_num = 7;
            data_in = 16'h2828;

            #1;


            check_outputs(16'h8822);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Small and large range");
            test_num = 8;
            data_in = 16'h0FE1;

            #1;


            check_outputs(16'hFE10);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Descending values at extremes");
            test_num = 9;
            data_in = 16'hE11E;

            #1;


            check_outputs(16'hEE11);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Single element different");
            test_num = 10;
            data_in = 16'hFFFF;
            data_in[3:0] = 4'hE;

            #1;


            check_outputs(16'hFFFE);
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
