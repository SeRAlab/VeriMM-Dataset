`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    reg [3:0] in5;
    reg [3:0] in6;
    reg [3:0] in7;
    reg [2:0] select;
    wire [3:0] out;

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
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select in0", test_num);
            in0 = 4'hA; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3;
            in4 = 4'h4; in5 = 4'h5; in6 = 4'h6; in7 = 4'h7;
            select = 3'b000;
            #5;
            #1;

            check_outputs(in0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select in1", test_num);
            in0 = 4'h0; in1 = 4'hB; in2 = 4'h2; in3 = 4'h3;
            in4 = 4'h4; in5 = 4'h5; in6 = 4'h6; in7 = 4'h7;
            select = 3'b001;
            #5;
            #1;

            check_outputs(in1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select in2", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'hC; in3 = 4'h3;
            in4 = 4'h4; in5 = 4'h5; in6 = 4'h6; in7 = 4'h7;
            select = 3'b010;
            #5;
            #1;

            check_outputs(in2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select in3", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'hD;
            in4 = 4'h4; in5 = 4'h5; in6 = 4'h6; in7 = 4'h7;
            select = 3'b011;
            #5;
            #1;

            check_outputs(in3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select in4", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3;
            in4 = 4'hE; in5 = 4'h5; in6 = 4'h6; in7 = 4'h7;
            select = 3'b100;
            #5;
            #1;

            check_outputs(in4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select in5", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3;
            in4 = 4'h4; in5 = 4'hF; in6 = 4'h6; in7 = 4'h7;
            select = 3'b101;
            #5;
            #1;

            check_outputs(in5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select in6", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3;
            in4 = 4'h4; in5 = 4'h5; in6 = 4'h7; in7 = 4'h0;
            select = 3'b110;
            #5;
            #1;

            check_outputs(in6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select in7", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3;
            in4 = 4'h4; in5 = 4'h5; in6 = 4'h6; in7 = 4'h9;
            select = 3'b111;
            #5;
            #1;

            check_outputs(in7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Dynamic Input Change", test_num);
            select = 3'b101;
            in5 = 4'h3;
            #5;
            in5 = 4'h8;
            #5;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: All Inputs High", test_num);
            in0 = 4'hF; in1 = 4'hF; in2 = 4'hF; in3 = 4'hF;
            in4 = 4'hF; in5 = 4'hF; in6 = 4'hF; in7 = 4'hF;
            select = 3'b011;
            #5;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_out;
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
