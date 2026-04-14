`timescale 1ns/1ps

module merge_sort_4_tb;

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
    merge_sort_4 dut (
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
            $display("Test Case %0d: Already Sorted", test_num);
            a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40;
            #1;

            check_outputs(8'd10, 8'd20, 8'd30, 8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Sorted", test_num);
            a = 8'd100; b = 8'd75; c = 8'd50; d = 8'd25;
            #1;

            check_outputs(8'd25, 8'd50, 8'd75, 8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Order 1", test_num);
            a = 8'hA5; b = 8'h12; c = 8'hFF; d = 8'h00;
            #1;

            check_outputs(8'h00, 8'h12, 8'hA5, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Order 2", test_num);
            a = 8'd42; b = 8'd7; c = 8'd42; d = 8'd1;
            #1;

            check_outputs(8'd1, 8'd7, 8'd42, 8'd42);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Identical", test_num);
            a = 8'hEE; b = 8'hEE; c = 8'hEE; d = 8'hEE;
            #1;

            check_outputs(8'hEE, 8'hEE, 8'hEE, 8'hEE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Pairs", test_num);
            a = 8'd5; b = 8'd50; c = 8'd5; d = 8'd50;
            #1;

            check_outputs(8'd5, 8'd5, 8'd50, 8'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Unique Smallest", test_num);
            a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd1;
            #1;

            check_outputs(8'd1, 8'd255, 8'd255, 8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Unique Largest", test_num);
            a = 8'd0; b = 8'd255; c = 8'd0; d = 8'd0;
            #1;

            check_outputs(8'd0, 8'd0, 8'd0, 8'd255);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Values", test_num);
            a = 8'h0F; b = 8'hF0; c = 8'h0F; d = 8'hF0;
            #1;

            check_outputs(8'h0F, 8'h0F, 8'hF0, 8'hF0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Near Values", test_num);
            a = 8'd128; b = 8'd127; c = 8'd129; d = 8'd126;
            #1;

            check_outputs(8'd126, 8'd127, 8'd128, 8'd129);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4 Testbench");
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
