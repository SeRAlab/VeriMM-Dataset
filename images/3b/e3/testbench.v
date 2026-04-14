`timescale 1ns/1ps

module conv2x2_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in00;
    reg [7:0] in01;
    reg [7:0] in10;
    reg [7:0] in11;
    reg [7:0] k00;
    reg [7:0] k01;
    reg [7:0] k10;
    reg [7:0] k11;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conv2x2 dut (
        .in00(in00),
        .in01(in01),
        .in10(in10),
        .in11(in11),
        .k00(k00),
        .k01(k01),
        .k10(k10),
        .k11(k11),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros", test_num);
            in00 = 8'd0; in01 = 8'd0; in10 = 8'd0; in11 = 8'd0;
            k00  = 8'd0; k01  = 8'd0; k10  = 8'd0; k11  = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Single element activation", test_num);
            in00 = 8'd10; in01 = 8'd20; in10 = 8'd30; in11 = 8'd40;
            k00  = 8'd1;  k01  = 8'd0;  k10  = 8'd0;  k11  = 8'd0;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Sum of all input elements", test_num);
            in00 = 8'd5;  in01 = 8'd10; in10 = 8'd15; in11 = 8'd20;
            k00  = 8'd1;  k01  = 8'd1;  k10  = 8'd1;  k11  = 8'd1;
            #1;

            check_outputs(16'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: General MAC operation", test_num);

            in00 = 8'd2; in01 = 8'd3; in10 = 8'd4; in11 = 8'd5;
            k00  = 8'd1; k01  = 8'd2; k10  = 8'd3; k11  = 8'd4;
            #1;

            check_outputs(16'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: High value inputs", test_num);

            in00 = 8'd100; in01 = 8'd100; in10 = 8'd100; in11 = 8'd100;
            k00  = 8'd100; k01  = 8'd100; k10  = 8'd100; k11  = 8'd100;
            #1;

            check_outputs(16'h9C40);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Max single product (255*255)", test_num);

            in00 = 8'hFF; in01 = 8'd0; in10 = 8'd0; in11 = 8'd0;
            k00  = 8'hFF; k01  = 8'd0; k10  = 8'd0; k11  = 8'd0;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Checkerboard pattern", test_num);

            in00 = 8'd10; in01 = 8'd0;  in10 = 8'd20; in11 = 8'd0;
            k00  = 8'd0;  k01  = 8'd10; k10  = 8'd0;  k11  = 8'd20;
            #1;

            check_outputs(16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("conv2x2 Testbench");
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
