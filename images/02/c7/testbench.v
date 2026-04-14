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
            test_num = 1;
            $display("Test Case %0d: Already Sorted", test_num);
            data_in = 20'h12345;
            #1;

            check_outputs(20'h12345);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reverse Sorted", test_num);
            data_in = 20'h54321;
            #1;

            check_outputs(20'h12345);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All Identical", test_num);
            data_in = 20'hAAAAA;
            #1;

            check_outputs(20'hAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Duplicates", test_num);
            data_in = 20'hF0F07;
            #1;

            check_outputs(20'h007FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Random Distribution", test_num);
            data_in = 20'h84C1A;
            #1;

            check_outputs(20'h148AC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Single high value at start", test_num);
            data_in = 20'hE2222;
            #1;

            check_outputs(20'h2222E);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Single low value at end", test_num);
            data_in = 20'hBBBB1;
            #1;

            check_outputs(20'h1BBBB);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Alternating High/Low", test_num);
            data_in = 20'hF1E2D;
            #1;

            check_outputs(20'h12DEF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Max and Min boundaries", test_num);
            data_in = 20'hF0F00;
            #1;

            check_outputs(20'h000FF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Zero-heavy", test_num);
            data_in = 20'h04010;
            #1;

            check_outputs(20'h00014);
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
