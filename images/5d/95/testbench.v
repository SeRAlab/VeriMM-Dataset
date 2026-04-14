`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg ctrl_data;
    reg ctrl_valid;
    reg din0_data;
    reg din0_valid;
    reg [1:0] din1_data;
    reg din1_valid;
    reg dout_ready;
    reg rst;
    wire ctrl_ready;
    wire din0_ready;
    wire din1_ready;
    wire [2:0] dout_data;
    wire dout_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ctrl_data(ctrl_data),
        .ctrl_valid(ctrl_valid),
        .din0_data(din0_data),
        .din0_valid(din0_valid),
        .din1_data(din1_data),
        .din1_valid(din1_valid),
        .dout_ready(dout_ready),
        .rst(rst),
        .ctrl_ready(ctrl_ready),
        .din0_ready(din0_ready),
        .din1_ready(din1_ready),
        .dout_data(dout_data),
        .dout_valid(dout_valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset State", test_num);
            rst = 1;
            clk = 0;
            ctrl_valid = 0; ctrl_data = 0;
            din0_valid = 0; din0_data = 0;
            din1_valid = 0; din1_data = 0;
            dout_ready = 0;
            #20;
            rst = 0;
            #5;

            #1;


            check_outputs(0, 0, 0, 3'b000, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Channel 0 Valid Transfer", test_num);
            rst = 1; #20; rst = 0; #10;

            ctrl_data = 1'b0; ctrl_valid = 1'b1;
            din0_data = 1'b1; din0_valid = 1'b1;
            din1_data = 2'b11; din1_valid = 1'b0;
            dout_ready = 1'b1;

            @(posedge clk); #1;

            #1;


            check_outputs(1, 1, 0, 3'b010, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Channel 1 Valid Transfer", test_num);
            rst = 1; #20; rst = 0; #10;

            ctrl_data = 1'b1; ctrl_valid = 1'b1;
            din1_data = 2'b10; din1_valid = 1'b1;
            din0_data = 1'b0; din0_valid = 1'b1;
            dout_ready = 1'b1;

            @(posedge clk); #1;

            #1;


            check_outputs(1, 0, 1, 3'b101, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Backpressure Logic", test_num);
            rst = 1; #20; rst = 0; #10;

            ctrl_data = 1'b1; ctrl_valid = 1'b1;
            din1_data = 2'b11; din1_valid = 1'b1;
            dout_ready = 1'b0;

            @(posedge clk); #1;

            #1;


            check_outputs(0, 0, 0, 3'b111, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Starvation (Missing Input Data)", test_num);
            rst = 1; #20; rst = 0; #10;

            ctrl_data = 1'b0; ctrl_valid = 1'b1;
            din0_valid = 1'b0;
            dout_ready = 1'b1;

            @(posedge clk); #1;


            #1;



            check_outputs(0, 1, 0, 3'b000, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Starvation (Missing Control)", test_num);
            rst = 1; #20; rst = 0; #10;

            ctrl_valid = 1'b0;
            din0_data = 1'b1; din0_valid = 1'b1;
            dout_ready = 1'b1;

            @(posedge clk); #1;


            #1;



            check_outputs(1, 0, 0, 3'b000, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Channel Isolation Check", test_num);
            rst = 1; #20; rst = 0; #10;

            ctrl_data = 1'b0; ctrl_valid = 1'b1;
            din0_data = 1'b1; din0_valid = 1'b1;
            din1_data = 2'b11; din1_valid = 1'b1;
            dout_ready = 1'b1;

            @(posedge clk); #1;

            #1;


            check_outputs(1, 1, 0, 3'b010, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Data Variation Check", test_num);
            rst = 1; #20; rst = 0; #10;

            ctrl_data = 1'b1; ctrl_valid = 1'b1;
            din1_data = 2'b01; din1_valid = 1'b1;
            dout_ready = 1'b1;

            @(posedge clk); #1;

            #1;


            check_outputs(1, 0, 1, 3'b011, 1);
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
        input expected_ctrl_ready;
        input expected_din0_ready;
        input expected_din1_ready;
        input [2:0] expected_dout_data;
        input expected_dout_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ctrl_ready === (expected_ctrl_ready ^ ctrl_ready ^ expected_ctrl_ready) &&
                expected_din0_ready === (expected_din0_ready ^ din0_ready ^ expected_din0_ready) &&
                expected_din1_ready === (expected_din1_ready ^ din1_ready ^ expected_din1_ready) &&
                expected_dout_data === (expected_dout_data ^ dout_data ^ expected_dout_data) &&
                expected_dout_valid === (expected_dout_valid ^ dout_valid ^ expected_dout_valid)) begin
                $display("PASS");
                $display("  Outputs: ctrl_ready=%b, din0_ready=%b, din1_ready=%b, dout_data=%h, dout_valid=%b",
                         ctrl_ready, din0_ready, din1_ready, dout_data, dout_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ctrl_ready=%b, din0_ready=%b, din1_ready=%b, dout_data=%h, dout_valid=%b",
                         expected_ctrl_ready, expected_din0_ready, expected_din1_ready, expected_dout_data, expected_dout_valid);
                $display("  Got:      ctrl_ready=%b, din0_ready=%b, din1_ready=%b, dout_data=%h, dout_valid=%b",
                         ctrl_ready, din0_ready, din1_ready, dout_data, dout_valid);
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
