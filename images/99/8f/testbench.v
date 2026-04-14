`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [3:0] in1_hi;
    wire [3:0] in1_lo;
    wire [3:0] in2_hi;
    wire [3:0] in2_lo;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .in1_hi(in1_hi),
        .in1_lo(in1_lo),
        .in2_hi(in2_hi),
        .in2_lo(in2_lo),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 16'h0000;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 16'hFFFF;

            #1;


            check_outputs(4'hF, 4'hF, 4'hF, 4'hF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 16'h9823;


            #1;



            check_outputs(4'h9, 4'h8, 4'h2, 4'h3, 8'h0C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 16'h2398;


            #1;



            check_outputs(4'h2, 4'h3, 4'h9, 4'h8, 8'h0C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 16'hF00F;


            #1;



            check_outputs(4'hF, 4'h0, 4'h0, 4'hF, 8'h1E);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 16'hA5A0;


            #1;



            check_outputs(4'hA, 4'h5, 4'hA, 4'h0, 8'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 16'hABCD;


            #1;



            check_outputs(4'hA, 4'hB, 4'hC, 4'hD, 8'h04);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 16'h55AA;


            #1;



            check_outputs(4'h5, 4'h5, 4'hA, 4'hA, 8'h0A);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 16'hF202;


            #1;



            check_outputs(4'hF, 4'h2, 4'h0, 4'h2, 8'h0F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 16'h7F70;


            #1;



            check_outputs(4'h7, 4'hF, 4'h7, 4'h0, 8'h0F);
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
        input [3:0] expected_in1_hi;
        input [3:0] expected_in1_lo;
        input [3:0] expected_in2_hi;
        input [3:0] expected_in2_lo;
        input [7:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in1_hi === (expected_in1_hi ^ in1_hi ^ expected_in1_hi) &&
                expected_in1_lo === (expected_in1_lo ^ in1_lo ^ expected_in1_lo) &&
                expected_in2_hi === (expected_in2_hi ^ in2_hi ^ expected_in2_hi) &&
                expected_in2_lo === (expected_in2_lo ^ in2_lo ^ expected_in2_lo) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: in1_hi=%h, in1_lo=%h, in2_hi=%h, in2_lo=%h, out=%h",
                         in1_hi, in1_lo, in2_hi, in2_lo, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in1_hi=%h, in1_lo=%h, in2_hi=%h, in2_lo=%h, out=%h",
                         expected_in1_hi, expected_in1_lo, expected_in2_hi, expected_in2_lo, expected_out);
                $display("  Got:      in1_hi=%h, in1_lo=%h, in2_hi=%h, in2_lo=%h, out=%h",
                         in1_hi, in1_lo, in2_hi, in2_lo, out);
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
