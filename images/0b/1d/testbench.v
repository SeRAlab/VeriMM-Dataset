`timescale 1ns/1ps

module merge_sort_4way_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4way dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Already sorted input", test_num);
            a = 4'h1; b = 4'h2; c = 4'h3; d = 4'h4;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse sorted input", test_num);
            a = 4'hD; b = 4'hC; c = 4'hB; d = 4'hA;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All identical values", test_num);
            a = 4'h7; b = 4'h7; c = 4'h7; d = 4'h7;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two pairs of duplicates", test_num);
            a = 4'h5; b = 4'h2; c = 4'h5; d = 4'h2;
            #1;

            check_outputs(16'h2255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single outlier (large)", test_num);
            a = 4'h1; b = 4'h0; c = 4'hF; d = 4'h2;
            #1;

            check_outputs(16'h012F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single outlier (small)", test_num);
            a = 4'hE; b = 4'hF; c = 4'hE; d = 4'h1;
            #1;

            check_outputs(16'h1EEF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum and Minimum values", test_num);
            a = 4'hF; b = 4'h0; c = 4'hF; d = 4'h0;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random permutation 1", test_num);
            a = 4'h9; b = 4'h4; c = 4'hB; d = 4'h1;
            #1;

            check_outputs(16'h149B);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random permutation 2", test_num);
            a = 4'h3; b = 4'h8; c = 4'h6; d = 4'h2;
            #1;

            check_outputs(16'h2368);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence with one repeated high value", test_num);
            a = 4'hA; b = 4'h5; c = 4'hA; d = 4'h3;
            #1;

            check_outputs(16'h35AA);
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
