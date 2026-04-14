`timescale 1ns/1ps

module merge_sort_4way_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4way dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Already Sorted Ascending", test_num);
            in0 = 4'h1; in1 = 4'h2; in2 = 4'h3; in3 = 4'h4;
            #1;

            check_outputs(16'h4321);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Sorted Descending", test_num);
            in0 = 4'h4; in1 = 4'h3; in2 = 4'h2; in3 = 4'h1;
            #1;

            check_outputs(16'h4321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Identical Values", test_num);
            in0 = 4'h7; in1 = 4'h7; in2 = 4'h7; in3 = 4'h7;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min and Max Bounds", test_num);
            in0 = 4'hF; in1 = 4'h0; in2 = 4'hF; in3 = 4'h0;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Duplicate Pairs", test_num);
            in0 = 4'h2; in1 = 4'hA; in2 = 4'h2; in3 = 4'hA;
            #1;

            check_outputs(16'hAA22);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Permutation 1", test_num);
            in0 = 4'hD; in1 = 4'h1; in2 = 4'h8; in3 = 4'h5;
            #1;

            check_outputs(16'hD851);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Three Identical Values", test_num);
            in0 = 4'h3; in1 = 4'h3; in2 = 4'hC; in3 = 4'h3;
            #1;

            check_outputs(16'hC333);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Range Values", test_num);
            in0 = 4'hE; in1 = 4'hF; in2 = 4'hB; in3 = 4'hD;
            #1;

            check_outputs(16'hFEDB);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Range Values", test_num);
            in0 = 4'h0; in1 = 4'h2; in2 = 4'h1; in3 = 4'h0;
            #1;

            check_outputs(16'h2100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Permutation 2", test_num);
            in0 = 4'h6; in1 = 4'hB; in2 = 4'h4; in3 = 4'h9;
            #1;

            check_outputs(16'hB964);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4way Testbench");
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
