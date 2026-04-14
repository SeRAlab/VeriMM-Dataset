`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] in1;
    reg [5:0] in10;
    reg [5:0] in11;
    reg [5:0] in12;
    reg [5:0] in13;
    reg [5:0] in14;
    reg [5:0] in15;
    reg [5:0] in16;
    reg [5:0] in2;
    reg [5:0] in3;
    reg [5:0] in4;
    reg [5:0] in5;
    reg [5:0] in6;
    reg [5:0] in7;
    reg [5:0] in8;
    reg [5:0] in9;
    reg [3:0] sel;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in10(in10),
        .in11(in11),
        .in12(in12),
        .in13(in13),
        .in14(in14),
        .in15(in15),
        .in16(in16),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .in8(in8),
        .in9(in9),
        .sel(sel),
        .out(out)
    );
    task initialize_inputs;

        begin
            in1  = 6'd1;  in2  = 6'd2;  in3  = 6'd3;  in4  = 6'd4;
            in5  = 6'd5;  in6  = 6'd6;  in7  = 6'd7;  in8  = 6'd8;
            in9  = 6'd9;  in10 = 6'd10; in11 = 6'd11; in12 = 6'd12;
            in13 = 6'd13; in14 = 6'd14; in15 = 6'd15; in16 = 6'd16;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select first input (in1)", test_num);
            initialize_inputs();
            sel = 4'd0;
            #1;

            check_outputs(6'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select last input (in16)", test_num);
            initialize_inputs();
            sel = 4'd15;
            #1;

            check_outputs(6'd16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select middle input (in8)", test_num);
            initialize_inputs();
            sel = 4'd7;
            #1;

            check_outputs(6'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs max value (6'h3F)", test_num);
            in1 = 6'h3F; in2 = 6'h3F; in3 = 6'h3F; in4 = 6'h3F;
            in5 = 6'h3F; in6 = 6'h3F; in7 = 6'h3F; in8 = 6'h3F;
            in9 = 6'h3F; in10 = 6'h3F; in11 = 6'h3F; in12 = 6'h3F;
            in13 = 6'h3F; in14 = 6'h3F; in15 = 6'h3F; in16 = 6'h3F;
            sel = 4'd10;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data change on selected channel", test_num);
            initialize_inputs();
            sel = 4'd4;
            #1;
            in5 = 6'h2A;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 0; in6 = 0; in7 = 0; in8 = 0;
            in9 = 0; in10 = 0; in11 = 0; in12 = 0; in13 = 0; in14 = 0; in15 = 0; in16 = 0;
            sel = 4'd13;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit pattern 101010", test_num);
            initialize_inputs();
            in3 = 6'b101010;
            sel = 4'd2;
            #1;

            check_outputs(6'b101010);
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
        input [5:0] expected_out;
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
