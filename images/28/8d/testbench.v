`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    wire [3:0] out1;
    wire [3:0] out2;
    wire [3:0] out3;
    wire [3:0] out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sorted Input (Already in order)", test_num);
            a = 4'h1; b = 4'h2; c = 4'h5; d = 4'h9;
            #1;

            check_outputs(4'h1, 4'h2, 4'h5, 4'h9);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reverse Sorted Input", test_num);
            a = 4'hF; b = 4'hA; c = 4'h5; d = 4'h0;
            #1;

            check_outputs(4'h0, 4'h5, 4'hA, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Elements Identical", test_num);
            a = 4'h7; b = 4'h7; c = 4'h7; d = 4'h7;
            #1;

            check_outputs(4'h7, 4'h7, 4'h7, 4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two Pairs of Identical Values", test_num);
            a = 4'h3; b = 4'hC; c = 4'h3; d = 4'hC;
            #1;

            check_outputs(4'h3, 4'h3, 4'hC, 4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Permutation 1", test_num);
            a = 4'hE; b = 4'h2; c = 4'hB; d = 4'h6;
            #1;

            check_outputs(4'h2, 4'h6, 4'hB, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Permutation 2 (Boundaries)", test_num);
            a = 4'hF; b = 4'h0; c = 4'hF; d = 4'h1;
            #1;

            check_outputs(4'h0, 4'h1, 4'hF, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: One Large Element", test_num);
            a = 4'h2; b = 4'h1; c = 4'h3; d = 4'hF;
            #1;

            check_outputs(4'h1, 4'h2, 4'h3, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: One Small Element", test_num);
            a = 4'hD; b = 4'hE; c = 4'h0; d = 4'hC;
            #1;

            check_outputs(4'h0, 4'hC, 4'hD, 4'hE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Three Identical Elements", test_num);
            a = 4'h4; b = 4'h8; c = 4'h4; d = 4'h4;
            #1;

            check_outputs(4'h4, 4'h4, 4'h4, 4'h8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Values", test_num);
            a = 4'h5; b = 4'h3; c = 4'h9; d = 4'h1;
            #1;

            check_outputs(4'h1, 4'h3, 4'h5, 4'h9);
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
        input [3:0] expected_out1;
        input [3:0] expected_out2;
        input [3:0] expected_out3;
        input [3:0] expected_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
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
