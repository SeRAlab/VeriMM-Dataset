`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;
    wire [7:0] out4;

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
            $display("Test %0d: Already Sorted Input", test_num);
            a = 8'h05; b = 8'h10; c = 8'h22; d = 8'hFF;
            #1;

            check_outputs(8'h05, 8'h10, 8'h22, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reverse Sorted Input", test_num);
            a = 8'hFF; b = 8'h22; c = 8'h10; d = 8'h05;
            #1;

            check_outputs(8'h05, 8'h10, 8'h22, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Permutation 1", test_num);
            a = 8'h45; b = 8'h02; d = 8'h11; c = 8'h88;
            #1;

            check_outputs(8'h02, 8'h11, 8'h45, 8'h88);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Permutation 2", test_num);
            a = 8'h0A; b = 8'hFF; c = 8'h0A; d = 8'h01;
            #1;

            check_outputs(8'h01, 8'h0A, 8'h0A, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Elements Same", test_num);
            a = 8'h55; b = 8'h55; c = 8'h55; d = 8'h55;
            #1;

            check_outputs(8'h55, 8'h55, 8'h55, 8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two Pairs", test_num);
            a = 8'hAA; b = 8'h11; c = 8'hAA; d = 8'h11;
            #1;

            check_outputs(8'h11, 8'h11, 8'hAA, 8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero and Max Values", test_num);
            a = 8'h00; b = 8'hFF; c = 8'h00; d = 8'hFF;
            #1;

            check_outputs(8'h00, 8'h00, 8'hFF, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Different Value (Max)", test_num);
            a = 8'h20; b = 8'h20; c = 8'h20; d = 8'hF0;
            #1;

            check_outputs(8'h20, 8'h20, 8'h20, 8'hF0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Different Value (Min)", test_num);
            a = 8'h20; b = 8'h20; c = 8'h05; d = 8'h20;
            #1;

            check_outputs(8'h05, 8'h20, 8'h20, 8'h20);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Values Sequence", test_num);
            a = 8'hFE; b = 8'hFD; c = 8'hFC; d = 8'hFB;
            #1;

            check_outputs(8'hFB, 8'hFC, 8'hFD, 8'hFE);
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
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_out3;
        input [7:0] expected_out4;
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
