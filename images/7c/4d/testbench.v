`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dn;
    reg n_rst;
    reg up;
    wire [3:0] cnt;
    wire out1;
    wire out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dn(dn),
        .n_rst(n_rst),
        .up(up),
        .cnt(cnt),
        .out1(out1),
        .out2(out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            n_rst = 0;
            up = 0;
            dn = 0;
            @(posedge clk);
            #2 n_rst = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Increment Once", test_num);
            reset_dut();
            up = 1; dn = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'd1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Increment to 5", test_num);
            reset_dut();
            up = 1; dn = 0;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(4'd5, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter Overflow (15 to 0)", test_num);
            reset_dut();
            up = 1; dn = 0;
            repeat(16) @(posedge clk);
            #2;

            #1;


            check_outputs(4'd0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter Underflow (0 to 15)", test_num);
            reset_dut();
            up = 0; dn = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hF, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Increment to 10 then Decrement to 7", test_num);
            reset_dut();
            up = 1; dn = 0;
            repeat(10) @(posedge clk);
            up = 0; dn = 1;
            repeat(3) @(posedge clk);
            #2;

            #1;


            check_outputs(4'd7, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No change (up=0, dn=0)", test_num);
            reset_dut();
            up = 1; dn = 0; @(posedge clk);
            up = 0; dn = 0; @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No change (up=1, dn=1)", test_num);
            reset_dut();
            up = 1; dn = 0; @(posedge clk);
            up = 1; dn = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1, 1'b0, 1'b1);
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
        input [3:0] expected_cnt;
        input expected_out1;
        input expected_out2;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h, out1=%b, out2=%b",
                         cnt, out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h, out1=%b, out2=%b",
                         expected_cnt, expected_out1, expected_out2);
                $display("  Got:      cnt=%h, out1=%b, out2=%b",
                         cnt, out1, out2);
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
        $dumpvars(0,clk, dn, n_rst, up, cnt, out1, out2);
    end

endmodule
