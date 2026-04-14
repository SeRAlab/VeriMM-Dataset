`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg dec;
    reg dir_last;
    reg en_in;
    reg [4:0] enc_period_curr;
    reg [4:0] enc_period_last;
    reg inc;
    reg inc_dec;
    reg process;
    wire dir_this;
    wire [4:0] enc_period_this;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dec(dec),
        .dir_last(dir_last),
        .en_in(en_in),
        .enc_period_curr(enc_period_curr),
        .enc_period_last(enc_period_last),
        .inc(inc),
        .inc_dec(inc_dec),
        .process(process),
        .dir_this(dir_this),
        .enc_period_this(enc_period_this)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            en_in = 0; process = 0; inc = 0; dec = 0; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;

            $display("Testcase %0d: Basic Increment Operation", test_num);
            en_in = 1; process = 1; inc = 1; dec = 0; inc_dec = 1;
            enc_period_curr = 5'h0A; dir_last = 0; enc_period_last = 5'h1F;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b1, 5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;

            en_in = 0; process = 0; inc = 0; dec = 0; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;

            $display("Testcase %0d: Basic Decrement Operation", test_num);
            en_in = 1; process = 1; inc = 0; dec = 1; inc_dec = 0;
            enc_period_curr = 5'h15; dir_last = 1; enc_period_last = 5'h05;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;

            en_in = 0; process = 0; inc = 0; dec = 0; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;

            $display("Testcase %0d: Disabled State (en_in=0)", test_num);
            en_in = 0; process = 1; inc = 1; dec = 0; inc_dec = 1;
            enc_period_curr = 5'h0A; dir_last = 0; enc_period_last = 5'h12;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 5'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;

            en_in = 0; process = 0; inc = 0; dec = 0; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;

            $display("Testcase %0d: Process Signal Low", test_num);
            en_in = 1; process = 0; inc = 1; dec = 0; inc_dec = 1;
            enc_period_curr = 5'h0A; dir_last = 1; enc_period_last = 5'h08;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b1, 5'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;

            en_in = 0; process = 0; inc = 0; dec = 0; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;

            $display("Testcase %0d: No Pulse (inc/dec low)", test_num);
            en_in = 1; process = 1; inc = 0; dec = 0; inc_dec = 1;
            enc_period_curr = 5'h0A; dir_last = 0; enc_period_last = 5'h04;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 5'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;

            en_in = 0; process = 0; inc = 0; dec = 0; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;

            $display("Testcase %0d: Boundary Value Max Period", test_num);
            en_in = 1; process = 1; inc = 1; dec = 0; inc_dec = 1;
            enc_period_curr = 5'h1F; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b1, 5'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;

            en_in = 0; process = 0; inc = 0; dec = 0; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;

            $display("Testcase %0d: Boundary Value Min Period", test_num);
            en_in = 1; process = 1; inc = 0; dec = 1; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 1; enc_period_last = 5'h1F;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b0, 5'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;

            en_in = 0; process = 0; inc = 0; dec = 0; inc_dec = 0;
            enc_period_curr = 5'h00; dir_last = 0; enc_period_last = 5'h00;
            clk = 0; #5; clk = 1; #5;

            $display("Testcase %0d: Combined Inc/Dec logic Check", test_num);
            en_in = 1; process = 1; inc = 1; dec = 1; inc_dec = 1;
            enc_period_curr = 5'h11; dir_last = 0; enc_period_last = 5'h05;
            clk = 0; #5; clk = 1; #5;
            #1;

            check_outputs(1'b1, 5'h11);
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
        input expected_dir_this;
        input [4:0] expected_enc_period_this;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dir_this === (expected_dir_this ^ dir_this ^ expected_dir_this) &&
                expected_enc_period_this === (expected_enc_period_this ^ enc_period_this ^ expected_enc_period_this)) begin
                $display("PASS");
                $display("  Outputs: dir_this=%b, enc_period_this=%h",
                         dir_this, enc_period_this);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dir_this=%b, enc_period_this=%h",
                         expected_dir_this, expected_enc_period_this);
                $display("  Got:      dir_this=%b, enc_period_this=%h",
                         dir_this, enc_period_this);
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
