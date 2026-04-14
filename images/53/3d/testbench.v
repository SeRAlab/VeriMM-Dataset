`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    reg [15:0] in3;
    reg [15:0] in4;
    wire [15:0] out1;
    wire [15:0] out2;
    wire [15:0] out3;
    wire [15:0] out4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            in1 = 16'd0; in2 = 16'd0; in3 = 16'd0; in4 = 16'd0;
            #1;

            check_outputs(16'd0, 16'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive values, sum divisible by 4", test_num);
            in1 = 16'd10; in2 = 16'd20; in3 = 16'd30; in4 = 16'd40;

            #1;


            check_outputs(16'd25, 16'd25, 16'd25, 16'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative values, sum divisible by 4", test_num);
            in1 = -16'd10; in2 = -16'd20; in3 = -16'd30; in4 = -16'd40;

            #1;


            check_outputs(-16'd25, -16'd25, -16'd25, -16'd25);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max positive values", test_num);
            in1 = 16'h7FFF; in2 = 16'h7FFF; in3 = 16'h7FFF; in4 = 16'h7FFF;

            #1;


            check_outputs(16'h7FFF, 16'h7FFF, 16'h7FFF, 16'h7FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max negative values", test_num);
            in1 = 16'h8000; in2 = 16'h8000; in3 = 16'h8000; in4 = 16'h8000;

            #1;


            check_outputs(16'h8000, 16'h8000, 16'h8000, 16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed values summing to zero", test_num);
            in1 = 16'd1000; in2 = -16'd1000; in3 = 16'd500; in4 = -16'd500;
            #1;

            check_outputs(16'd0, 16'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Truncation check (Positive sum)", test_num);
            in1 = 16'd1; in2 = 16'd1; in3 = 16'd1; in4 = 16'd2;

            #1;


            check_outputs(16'd1, 16'd1, 16'd1, 16'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Truncation check (Negative sum)", test_num);
            in1 = -16'd1; in2 = -16'd1; in3 = -16'd1; in4 = -16'd2;

            #1;


            check_outputs(-16'd1, -16'd1, -16'd1, -16'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large mixed values", test_num);
            in1 = 16'h7000; in2 = 16'h7000; in3 = -16'h1000; in4 = -16'h1000;


            #1;



            check_outputs(16'h3000, 16'h3000, 16'h3000, 16'h3000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single large value check", test_num);
            in1 = 16'd4000; in2 = 16'd0; in3 = 16'd0; in4 = 16'd0;

            #1;


            check_outputs(16'd1000, 16'd1000, 16'd1000, 16'd1000);
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
        input [15:0] expected_out1;
        input [15:0] expected_out2;
        input [15:0] expected_out3;
        input [15:0] expected_out4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3) &&
                expected_out4 === (expected_out4 ^ out4 ^ expected_out4)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h, out3=%h, out4=%h",
                         expected_out1, expected_out2, expected_out3, expected_out4);
                $display("  Got:      out1=%h, out2=%h, out3=%h, out4=%h",
                         out1, out2, out3, out4);
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
