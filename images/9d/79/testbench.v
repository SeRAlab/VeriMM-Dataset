`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] ba;
    wire [7:0] bs;
    wire [7:0] fa;
    wire [7:0] fs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .ba(ba),
        .bs(bs),
        .fa(fa),
        .fs(fs)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 8'd0; b = 8'd0;
            c = 8'd0; d = 8'd0;

            #1;


            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition and Subtraction", test_num);
            a = 8'd10; b = 8'd5;
            c = 8'd20; d = 8'd3;

            #1;


            check_outputs(8'h17, 8'h11, 8'h0F, 8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow and Underflow (Two's Complement)", test_num);
            a = 8'hFF; b = 8'h01;
            c = 8'h00; d = 8'h01;
            #1;

            check_outputs(8'h01, 8'hFF, 8'h00, 8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Positive/Negative Bounds", test_num);
            a = 8'd128; b = 8'd128;
            c = 8'h80;  d = 8'hFF;
            #1;

            check_outputs(8'h7F, 8'h81, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            a = 8'hAA; b = 8'h55;
            c = 8'hF0; d = 0x0F;
            #1;

            check_outputs(8'hFF, 8'hE1, 8'hFF, 8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Same Operands for Both Sets", test_num);
            a = 8'd50; b = 8'd25;
            c = 8'd50; d = 8'd25;

            #1;


            check_outputs(8'h4B, 8'h19, 8'h4B, 8'h19);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_ba;
        input [7:0] expected_bs;
        input [7:0] expected_fa;
        input [7:0] expected_fs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ba === (expected_ba ^ ba ^ expected_ba) &&
                expected_bs === (expected_bs ^ bs ^ expected_bs) &&
                expected_fa === (expected_fa ^ fa ^ expected_fa) &&
                expected_fs === (expected_fs ^ fs ^ expected_fs)) begin
                $display("PASS");
                $display("  Outputs: ba=%h, bs=%h, fa=%h, fs=%h",
                         ba, bs, fa, fs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ba=%h, bs=%h, fa=%h, fs=%h",
                         expected_ba, expected_bs, expected_fa, expected_fs);
                $display("  Got:      ba=%h, bs=%h, fa=%h, fs=%h",
                         ba, bs, fa, fs);
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
