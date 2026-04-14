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
            $display("\nTestcase %0d: Already Sorted Array", test_num);

            data_in = {4'h1, 4'h2, 4'h3, 4'h4, 4'h5};

            #1;


            check_outputs({4'h1, 4'h2, 4'h3, 4'h4, 4'h5});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reverse Sorted Array", test_num);

            data_in = {4'h5, 4'h4, 4'h3, 4'h2, 4'h1};

            #1;


            check_outputs({4'h1, 4'h2, 4'h3, 4'h4, 4'h5});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Duplicates", test_num);

            data_in = {4'h3, 4'h1, 4'h3, 4'h2, 4'h1};

            #1;


            check_outputs({4'h1, 4'h1, 4'h2, 4'h3, 4'h3});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Identical", test_num);

            data_in = {4'h7, 4'h7, 4'h7, 4'h7, 4'h7};

            #1;


            check_outputs({4'h7, 4'h7, 4'h7, 4'h7, 4'h7});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Min/Max Values", test_num);

            data_in = {4'hA, 4'h0, 4'hF, 4'h2, 4'h8};

            #1;


            check_outputs({4'h0, 4'h2, 4'h8, 4'hA, 4'hF});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Near-Sorted Array", test_num);

            data_in = {4'h1, 4'h2, 4'h3, 4'h5, 4'h4};

            #1;


            check_outputs({4'h1, 4'h2, 4'h3, 4'h4, 4'h5});
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
