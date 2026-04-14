`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [7:0] e;
    wire [7:0] out1;
    wire [7:0] out2;
    wire [7:0] out3;
    wire [7:0] out4;
    wire [7:0] out5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .out5(out5)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Already Sorted", test_num);
            a = 8'd10; b = 8'd20; c = 8'd30; d = 8'd40; e = 8'd50;
            #1;

            check_outputs(8'd10, 8'd20, 8'd30, 8'd40, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reverse Sorted", test_num);
            a = 8'd55; b = 8'd44; c = 8'd33; d = 8'd22; e = 8'd11;
            #1;

            check_outputs(8'd11, 8'd22, 8'd33, 8'd44, 8'd55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Identical Values", test_num);
            a = 8'hFF; b = 8'hFF; c = 8'hFF; d = 8'hFF; e = 8'hFF;
            #1;

            check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum and Maximum Values", test_num);
            a = 8'h00; b = 8'hFF; c = 8'h00; d = 8'hFF; e = 8'h7F;
            #1;

            check_outputs(8'h00, 8'h00, 8'h7F, 8'hFF, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Duplicates and Random Order", test_num);
            a = 8'd42; b = 8'd7; c = 8'd42; d = 8'd1; e = 8'd7;
            #1;

            check_outputs(8'd1, 8'd7, 8'd7, 8'd42, 8'd42);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Smallest at the End", test_num);
            a = 8'd100; b = 8'd110; c = 8'd120; d = 8'd130; e = 8'd5;
            #1;

            check_outputs(8'd5, 8'd100, 8'd110, 8'd120, 8'd130);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Largest at the Front", test_num);
            a = 8'd250; b = 8'd10; c = 8'd20; d = 8'd30; e = 8'd40;
            #1;

            check_outputs(8'd10, 8'd20, 8'd30, 8'd40, 8'd250);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary Set 1", test_num);
            a = 8'h12; b = 8'hA5; c = 8'h03; d = 8'h7F; e = 8'h44;
            #1;

            check_outputs(8'h03, 8'h12, 8'h44, 8'h7F, 8'hA5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary Set 2", test_num);
            a = 8'd88; b = 8'd2; d = 8'd15; c = 8'd200; e = 8'd64;
            #1;

            check_outputs(8'd2, 8'd15, 8'd64, 8'd88, 8'd200);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Values", test_num);
            a = 8'd1; b = 8'd10; c = 8'd1; d = 8'd10; e = 8'd1;
            #1;

            check_outputs(8'd1, 8'd1, 8'd1, 8'd10, 8'd10);
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
        input [7:0] expected_out1;
        input [7:0] expected_out2;
        input [7:0] expected_out3;
        input [7:0] expected_out4;
        input [7:0] expected_out5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4) &&
                expected_out5 === (expected_out5 ^ out5 ^ expected_out5)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h, out5=%h",
                         out1, out2, out3, out4, out5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h, out5=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4, expected_out5);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h, out5=%h",
                         out1, out2, out3, out4, out5);
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
