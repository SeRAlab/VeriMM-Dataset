`timescale 1ns/1ps

module alu_mux_8_tb;

    // Testbench signals (combinational circuit)
    reg in0;
    reg in1;
    reg in2;
    reg in3;
    reg in4;
    reg in5;
    reg in6;
    reg in7;
    reg [2:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_mux_8 dut (
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
            in0 = 1; in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 0; in6 = 0; in7 = 0;
            sel = 3'd0;
            $display("Test Case %0d: Selecting in0 (set to 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in0 = 0; in1 = 1; in2 = 0; in3 = 0; in4 = 0; in5 = 0; in6 = 0; in7 = 0;
            sel = 3'd1;
            $display("Test Case %0d: Selecting in1 (set to 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in0 = 0; in1 = 0; in2 = 1; in3 = 0; in4 = 0; in5 = 0; in6 = 0; in7 = 0;
            sel = 3'd2;
            $display("Test Case %0d: Selecting in2 (set to 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in0 = 0; in1 = 0; in2 = 0; in3 = 1; in4 = 0; in5 = 0; in6 = 0; in7 = 0;
            sel = 3'd3;
            $display("Test Case %0d: Selecting in3 (set to 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 1; in5 = 0; in6 = 0; in7 = 0;
            sel = 3'd4;
            $display("Test Case %0d: Selecting in4 (set to 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 1; in6 = 0; in7 = 0;
            sel = 3'd5;
            $display("Test Case %0d: Selecting in5 (set to 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 0; in6 = 1; in7 = 0;
            sel = 3'd6;
            $display("Test Case %0d: Selecting in6 (set to 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in0 = 0; in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 0; in6 = 0; in7 = 1;
            sel = 3'd7;
            $display("Test Case %0d: Selecting in7 (set to 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in0 = 0; in1 = 1; in2 = 1; in3 = 1; in4 = 1; in5 = 1; in6 = 1; in7 = 1;
            sel = 3'd0;
            $display("Test Case %0d: Selecting in0=0 while other inputs are 1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in0 = 1; in1 = 1; in2 = 1; in3 = 1; in4 = 1; in5 = 1; in6 = 1; in7 = 0;
            sel = 3'd7;
            $display("Test Case %0d: Selecting in7=0 while other inputs are 1", test_num);
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
        $display("alu_mux_8 Testbench");
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
