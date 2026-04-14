`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    wire [63:0] data_out;

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
            $display("\nTestcase %0d: Already Sorted", test_num);
            data_in = 64'h0807060504030201;
            #1;

            check_outputs(64'h0807060504030201);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reverse Sorted", test_num);
            data_in = 64'h0102030405060708;
            #1;

            check_outputs(64'h0807060504030201);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Duplicates", test_num);
            data_in = 64'h0205010201050205;

            #1;


            check_outputs(64'h0505050202020101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random Mix 1", test_num);
            data_in = 64'h124480FF01200510;

            #1;


            check_outputs(64'hFF80442012100501);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Identical", test_num);
            data_in = 64'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Extremes (Min/Max)", test_num);
            data_in = 64'h00FF01FE00FF01FE;

            #1;


            check_outputs(64'hFFFFFEFE01010000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random Mix 2", test_num);
            data_in = 64'hA522C109F03B8842;


            #1;



            check_outputs(64'hF0C1A588423B2209);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Outlier", test_num);
            data_in = 64'h7F7F7F7F7F7F7F01;
            #1;

            check_outputs(64'h7F7F7F7F7F7F7F01);
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
        input [63:0] expected_data_out;
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
