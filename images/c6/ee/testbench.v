`timescale 1ns/1ps

module five_to_one_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] in1;
    reg [2:0] in2;
    reg in3;
    reg [3:0] in4;
    reg [1:0] in5;
    wire out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    five_to_one dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .out1(out1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in1 = 2'd0; in2 = 3'd0; in3 = 1'b0; in4 = 4'd0; in5 = 2'd0;
            $display("Test Case %0d: All inputs zero (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in1 = 2'd2; in2 = 3'd0; in3 = 1'b0; in4 = 4'd0; in5 = 2'd0;
            $display("Test Case %0d: in1 condition (in1=2, Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in1 = 2'd1; in2 = 3'd4; in3 = 1'b0; in4 = 4'd0; in5 = 2'd0;
            $display("Test Case %0d: in2 condition (in2=4, Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in1 = 2'd0; in2 = 3'd3; in3 = 1'b1; in4 = 4'd0; in5 = 2'd0;
            $display("Test Case %0d: in3 condition (in3=1, Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in1 = 2'd0; in2 = 3'd0; in3 = 1'b0; in4 = 4'd3; in5 = 2'd2;
            $display("Test Case %0d: Sum condition (in4+in5=5, Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in1 = 2'd1; in2 = 3'd3; in3 = 1'b0; in4 = 4'd4; in5 = 2'd0;
            $display("Test Case %0d: All conditions just below threshold (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in1 = 2'd1; in2 = 3'd2; in3 = 1'b0; in4 = 4'd1; in5 = 2'd3;
            $display("Test Case %0d: Sum condition failure (in4+in5=4, Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in1 = 2'd3; in2 = 3'd7; in3 = 1'b1; in4 = 4'd15; in5 = 2'd3;
            $display("Test Case %0d: All conditions met (Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in1 = 2'd1; in2 = 3'd0; in3 = 1'b0; in4 = 4'd10; in5 = 2'd0;
            $display("Test Case %0d: in4 > 5 but in5 is 0 (Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in1 = 2'd0; in2 = 3'd0; in3 = 1'b0; in4 = 4'd0; in5 = 2'd3;
            $display("Test Case %0d: in5 high but sum < 5 (Expected: 0)", test_num);
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
        $display("five_to_one Testbench");
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
        input expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%b",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b",
                         expected_out1);
                $display("  Got:      out1=%b",
                         out1);
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
