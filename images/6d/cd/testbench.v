`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    reg [2:0] sel;
    wire [3:0] final_output;
    wire [3:0] out_and;
    wire [3:0] out_or;
    wire [3:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .sel(sel),
        .final_output(final_output),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            $display("Running testcase001: sel=0, in1-4=0xF");
            test_num = 1;
            sel = 3'd0;
            data0 = 4'hA; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
            in1 = 4'hF; in2 = 4'hF; in3 = 4'hF; in4 = 4'hF;

            #1;


            check_outputs(4'hA, 4'hF, 4'hF, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: sel=1, in1-4=0x0");
            test_num = 2;
            sel = 3'd1;
            data0 = 4'h0; data1 = 4'hB; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
            in1 = 4'h0; in2 = 4'h0; in3 = 4'h0; in4 = 4'h0;

            #1;


            check_outputs(4'hB, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: sel=2, in=A,5,A,5");
            test_num = 3;
            sel = 3'd2;
            data0 = 4'h0; data1 = 4'h0; data2 = 4'hC; data3 = 4'h0; data4 = 4'h0; data5 = 4'h0;
            in1 = 4'hA; in2 = 4'h5; in3 = 4'hA; in4 = 4'h5;

            #1;


            check_outputs(4'hC, 4'h0, 4'hF, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: sel=3, in=1,2,4,8");
            test_num = 4;
            sel = 3'd3;
            data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'hD; data4 = 4'h0; data5 = 4'h0;
            in1 = 4'h1; in2 = 4'h2; in3 = 4'h4; in4 = 4'h8;

            #1;


            check_outputs(4'hD, 4'h0, 4'hF, 4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: sel=4, in=3,3,3,3");
            test_num = 5;
            sel = 3'd4;
            data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'hE; data5 = 4'h0;
            in1 = 4'h3; in2 = 4'h3; in3 = 4'h3; in4 = 4'h3;

            #1;


            check_outputs(4'hE, 4'h3, 4'h3, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: sel=5, in=F,0,F,0");
            test_num = 6;
            sel = 3'd5;
            data0 = 4'h0; data1 = 4'h0; data2 = 4'h0; data3 = 4'h0; data4 = 4'h0; data5 = 4'hF;
            in1 = 4'hF; in2 = 4'h0; in3 = 4'hF; in4 = 4'h0;

            #1;


            check_outputs(4'hF, 4'h0, 4'hF, 4'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: sel=6 (Default/Null)");
            test_num = 7;
            sel = 3'd6;
            data0 = 4'h1; data1 = 4'h2; data2 = 4'h3; data3 = 4'h4; data4 = 4'h5; data5 = 4'h6;
            in1 = 4'h7; in2 = 4'h7; in3 = 4'h7; in4 = 4'h0;

            #1;


            check_outputs(4'h0, 4'h0, 4'h7, 4'h7);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Logic check independent of sel");
            test_num = 8;
            sel = 3'd0;
            data0 = 4'h9;
            in1 = 4'h1; in2 = 4'h1; in3 = 4'h1; in4 = 4'h1;

            #1;


            check_outputs(4'h9, 4'h1, 4'h1, 4'h0);
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
        input [3:0] expected_final_output;
        input [3:0] expected_out_and;
        input [3:0] expected_out_or;
        input [3:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_out_and === (expected_out_and ^ out_and ^ expected_out_and) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, out_and=%h, out_or=%h, out_xor=%h",
                         final_output, out_and, out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, out_and=%h, out_or=%h, out_xor=%h",
                         expected_final_output, expected_out_and, expected_out_or, expected_out_xor);
                $display("  Got:      final_output=%h, out_and=%h, out_or=%h, out_xor=%h",
                         final_output, out_and, out_or, out_xor);
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
