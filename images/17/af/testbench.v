`timescale 1ns/1ps

module quick_sort_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] array_in;
    reg start;
    wire [63:0] array_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quick_sort dut (
        .array_in(array_in),
        .start(start),
        .array_out(array_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Already Sorted", test_num);
            array_in = 64'h0807060504030201;
            start = 1;
            #1;

            check_outputs(64'h0807060504030201);
            start = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Reverse Sorted", test_num);
            array_in = 64'h0102030405060708;
            start = 1;
            #1;

            check_outputs(64'h0807060504030201);
            start = 0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Duplicates", test_num);
            array_in = 64'h0405030502050105;
            start = 1;
            #1;

            check_outputs(64'h0505050504030201);
            start = 0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Random Unsigned Integers", test_num);
            array_in = 64'h2177FE08C134A512;
            start = 1;

            #1;


            check_outputs(64'hFEC1A57734211208);
            start = 0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Identical", test_num);
            array_in = 64'hFFFFFFFFFFFFFFFF;
            start = 1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
            start = 0;
            #10;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating Extremes", test_num);
            array_in = 64'hFC03FD02FE01FF00;
            start = 1;
            #1;

            check_outputs(64'hFFFEFDFCC03020100);
            #1;

            check_outputs(64'hFFFEFDFCC03020100);

            #1;


            check_outputs(64'hFFFEFDFC03020100);
            start = 0;
            #10;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quick_sort Testbench");
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
        input [63:0] expected_array_out;
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
