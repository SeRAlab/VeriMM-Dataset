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
    reg [3:0] sel;
    wire out;

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
            $display("Test %0d: Select in0, input is 8'h00 (Expect out=0)", test_num);
            sel = 4'h0;
            in0 = 8'h00; in1 = 8'hFF; in2 = 8'hFF; in3 = 8'hFF;
            in4 = 8'hFF; in5 = 8'hFF; in6 = 8'hFF; in7 = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select in0, input is 8'h01 (Expect out=1)", test_num);
            sel = 4'h0;
            in0 = 8'h01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select in1, input is 8'h80 (Expect out=1)", test_num);
            sel = 4'h1;
            in1 = 8'h80; in0 = 8'h00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select in1, input is 8'h00 (Expect out=0)", test_num);
            sel = 4'h1;
            in1 = 8'h00; in0 = 8'hFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select in2, input is 8'hAA (Expect out=1)", test_num);
            sel = 4'h2;
            in2 = 8'hAA;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select in3, input is 8'h55 (Expect out=1)", test_num);
            sel = 4'h3;
            in3 = 8'h55;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Select in4, input is 8'h00 (Expect out=0)", test_num);
            sel = 4'h4;
            in4 = 8'h00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Select in5, input is 8'h08 (Expect out=1)", test_num);
            sel = 4'h5;
            in5 = 8'h08;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Select in6, input is 8'h00 (Expect out=0)", test_num);
            sel = 4'h6;
            in6 = 8'h00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Select in7, input is 8'hFF (Expect out=1)", test_num);
            sel = 4'h7;
            in7 = 8'hFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Switch Select from in7 to in6 (Expect out change 1->0)", test_num);
            in7 = 8'hFF; in6 = 8'h00;
            sel = 4'h7;
            #5;
            sel = 4'h6;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: All inputs except selected are HIGH (Expect out=0)", test_num);
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'h00; in3 = 8'hFF;
            in4 = 8'hFF; in5 = 8'hFF; in6 = 8'hFF; in7 = 8'hFF;
            sel = 4'h2;
            #1;

            check_outputs(1'b0);
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
        testcase011();
        testcase012();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
