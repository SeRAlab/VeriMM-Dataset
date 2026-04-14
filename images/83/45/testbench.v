`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg [7:0] in5;
    reg [7:0] in6;
    reg [7:0] in7;
    reg [2:0] sel;
    wire [7:0] out;

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
            in0 = 8'h00; in1 = 8'h11; in2 = 8'h22; in3 = 8'h33;
            in4 = 8'h44; in5 = 8'h55; in6 = 8'h66; in7 = 8'h77;
            sel = 3'd0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0 = 8'h00; in1 = 8'h11; in2 = 8'h22; in3 = 8'h33;
            in4 = 8'h44; in5 = 8'h55; in6 = 8'h66; in7 = 8'h77;
            sel = 3'd1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0 = 8'h00; in1 = 8'h11; in2 = 8'h22; in3 = 8'h33;
            in4 = 8'h44; in5 = 8'h55; in6 = 8'h66; in7 = 8'h77;
            sel = 3'd2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in0 = 8'h00; in1 = 8'h11; in2 = 8'h22; in3 = 8'h33;
            in4 = 8'h44; in5 = 8'h55; in6 = 8'h66; in7 = 8'h77;
            sel = 3'd3;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in0 = 8'h00; in1 = 8'h11; in2 = 8'h22; in3 = 8'h33;
            in4 = 8'h44; in5 = 8'h55; in6 = 8'h66; in7 = 8'h77;
            sel = 3'd4;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in0 = 8'h00; in1 = 8'h11; in2 = 8'h22; in3 = 8'h33;
            in4 = 8'h44; in5 = 8'h55; in6 = 8'h66; in7 = 8'h77;
            sel = 3'd5;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in0 = 8'h00; in1 = 8'h11; in2 = 8'h22; in3 = 8'h33;
            in4 = 8'h44; in5 = 8'h55; in6 = 8'h66; in7 = 8'h77;
            sel = 3'd6;
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in0 = 8'h00; in1 = 8'h11; in2 = 8'h22; in3 = 8'h33;
            in4 = 8'h44; in5 = 8'h55; in6 = 8'h66; in7 = 8'h77;
            sel = 3'd7;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in3 = 8'hFF;
            sel = 3'd3;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in0 = 8'hAA; in1 = 8'hAA; in2 = 8'hAA; in3 = 8'hAA;
            in4 = 8'hAA; in5 = 8'hAA; in6 = 8'hAA; in7 = 8'hAA;
            sel = 3'd4;
            #1;

            check_outputs(8'hAA);
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
        input [7:0] expected_out;
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
