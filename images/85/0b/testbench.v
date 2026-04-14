`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in0;
    reg [15:0] in1;
    reg [15:0] in2;
    reg [15:0] in3;
    reg [15:0] in4;
    reg [15:0] in5;
    reg [15:0] in6;
    reg [15:0] in7;
    reg [2:0] sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select in0", test_num);
            in0 = 16'hAAAA; in1 = 16'h0000; in2 = 16'h0000; in3 = 16'h0000;
            in4 = 16'h0000; in5 = 16'h0000; in6 = 16'h0000; in7 = 16'h0000;
            sel = 3'b000;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select in1", test_num);
            in0 = 16'h0000; in1 = 16'h5555; in2 = 16'h0000; in3 = 16'h0000;
            in4 = 16'h0000; in5 = 16'h0000; in6 = 16'h0000; in7 = 16'h0000;
            sel = 3'b001;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select in2", test_num);
            in0 = 16'hFFFF; in1 = 16'hFFFF; in2 = 16'h1234; in3 = 16'hFFFF;
            in4 = 16'hFFFF; in5 = 16'hFFFF; in6 = 16'hFFFF; in7 = 16'hFFFF;
            sel = 3'b010;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select in3", test_num);
            in3 = 16'h4321;
            sel = 3'b011;
            #1;

            check_outputs(16'h4321);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select in4", test_num);
            in4 = 16'hDEAD;
            sel = 3'b100;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select in5", test_num);
            in5 = 16'hBEEF;
            sel = 3'b101;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select in6", test_num);
            in6 = 16'h0001;
            sel = 3'b110;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select in7", test_num);
            in7 = 16'h8000;
            sel = 3'b111;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: All inputs unique, cycling selector", test_num);
            in0 = 16'h0; in1 = 16'h1; in2 = 16'h2; in3 = 16'h3;
            in4 = 16'h4; in5 = 16'h5; in6 = 16'h6; in7 = 16'h7;

            sel = 3'd0; #1;
 check_outputs(16'h0);
            sel = 3'd4; #1;
 check_outputs(16'h4);
            sel = 3'd2; #1;
 check_outputs(16'h2);
            sel = 3'd6; #1;
 check_outputs(16'h6);
            sel = 3'd1; #1;
 check_outputs(16'h1);
            sel = 3'd5; #1;
 check_outputs(16'h5);
            sel = 3'd3; #1;
 check_outputs(16'h3);
            sel = 3'd7; #1;
 check_outputs(16'h7);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Data transparency check", test_num);
            sel = 3'b011;
            in3 = 16'h0000; #1;
            in3 = 16'hFFFF; #1;
            in3 = 16'hA5A5;
            #1;

            check_outputs(16'hA5A5);
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
