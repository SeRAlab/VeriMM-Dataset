`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] aen;
    reg clk;
    reg [15:0] num;
    wire [3:0] an;
    wire dp;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aen(aen),
        .clk(clk),
        .num(num),
        .an(an),
        .dp(dp),
        .seg(seg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            aen = 4'b0000;
            num = 16'h0000;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            num = 16'h1234;
            aen = 4'b1111;


            repeat(1) @(posedge clk);



            #1;




            check_outputs(4'b1110, 1'b1, 7'h66);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            num = 16'h1234;
            aen = 4'b1111;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(4'b1101, 1'b1, 7'h4f);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            num = 16'h1234;
            aen = 4'b1111;
            repeat(3) @(posedge clk);

            #1;


            check_outputs(4'b1011, 1'b1, 7'h5b);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            num = 16'h1234;
            aen = 4'b1111;
            repeat(4) @(posedge clk);

            #1;


            check_outputs(4'b0111, 1'b1, 7'h06);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            num = 16'h9999;
            aen = 4'b1110;
            repeat(1) @(posedge clk);


            if (an[0] == 1'b1) begin
                $display("PASS: Digit 0 correctly masked by aen");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Digit 0 not masked by aen. an=%b", an);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            num = 16'h0000;
            aen = 4'b1111;
            repeat(1) @(posedge clk);

            #1;


            check_outputs(4'b1110, 1'b1, 7'h3f);
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
        input [3:0] expected_an;
        input expected_dp;
        input [6:0] expected_seg;
        begin
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp) &&
                expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: an=%h, dp=%b, seg=%h",
                         an, dp, seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, dp=%b, seg=%h",
                         expected_an, expected_dp, expected_seg);
                $display("  Got:      an=%h, dp=%b, seg=%h",
                         an, dp, seg);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,aen, clk, num, an, dp, seg);
    end

endmodule
