`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    reg [3:0] in5;
    reg [3:0] sel;
    wire [3:0] mux_out;

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
        .sel(sel),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select in0", test_num);
            in0 = 4'hA; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3; in4 = 4'h4; in5 = 4'h5;
            sel = 4'd0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select in1", test_num);
            in0 = 4'h0; in1 = 4'hB; in2 = 4'h2; in3 = 4'h3; in4 = 4'h4; in5 = 4'h5;
            sel = 4'd1;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select in2", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'hC; in3 = 4'h3; in4 = 4'h4; in5 = 4'h5;
            sel = 4'd2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select in3", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'hD; in4 = 4'h4; in5 = 4'h5;
            sel = 4'd3;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select in4", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3; in4 = 4'hE; in5 = 4'h5;
            sel = 4'd4;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select in5", test_num);
            in0 = 4'h0; in1 = 4'h1; in2 = 4'h2; in3 = 4'h3; in4 = 4'h4; in5 = 4'hF;
            sel = 4'd5;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select out of range (sel=6)", test_num);
            in0 = 4'h1; in1 = 4'h2; in2 = 4'h3; in3 = 4'h4; in4 = 4'h5; in5 = 4'h6;
            sel = 4'd6;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select out of range (sel=15)", test_num);
            in0 = 4'hF; in1 = 4'hF; in2 = 4'hF; in3 = 4'hF; in4 = 4'hF; in5 = 4'hF;
            sel = 4'd15;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Verify default 0 on sel=7", test_num);
            in0 = 4'h5; in1 = 4'h5; in2 = 4'h5; in3 = 4'h5; in4 = 4'h5; in5 = 4'h5;
            sel = 4'd7;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
