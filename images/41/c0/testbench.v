`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [1:0] sel;
    wire [7:0] y;

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
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0 (sel=00)", test_num);
            in0 = 8'hA5; in1 = 8'h00; in2 = 8'hFF; in3 = 8'h12;
            sel = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1 (sel=01)", test_num);
            in0 = 8'hA5; in1 = 8'h5A; in2 = 8'hFF; in3 = 8'h12;
            sel = 2'b01;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2 (sel=10)", test_num);
            in0 = 8'hA5; in1 = 8'h5A; in2 = 8'hC3; in3 = 8'h12;
            sel = 2'b10;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in3 (sel=11)", test_num);
            in0 = 8'hA5; in1 = 8'h5A; in2 = 8'hC3; in3 = 8'h3C;
            sel = 2'b11;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs same (sel=10)", test_num);
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'hFF; in3 = 8'hFF;
            sel = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero (sel=01)", test_num);
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            sel = 2'b01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data dynamic routing on in0", test_num);
            sel = 2'b00;
            in0 = 8'h11; #1;
            in0 = 8'h22; #1;
            in0 = 8'h77;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data dynamic routing on in3", test_num);
            sel = 2'b11;
            in3 = 8'hAA; #1;
            in3 = 8'hBB; #1;
            in3 = 8'hEE;
            #1;

            check_outputs(8'hEE);
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
