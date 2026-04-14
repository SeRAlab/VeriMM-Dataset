`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] cur_pwm;
    reg en;
    reg pre_first;
    reg [3:0] pwm_code;
    reg [7:0] pwm_cycle;
    reg [2:0] pwm_delay;
    reg [2:0] spread;
    wire [1:0] mot;
    wire [2:0] new_pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cur_pwm(cur_pwm),
        .en(en),
        .pre_first(pre_first),
        .pwm_code(pwm_code),
        .pwm_cycle(pwm_cycle),
        .pwm_delay(pwm_delay),
        .spread(spread),
        .mot(mot),
        .new_pwm(new_pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            pre_first = 0;
            pwm_delay = 3'b000;
            pwm_cycle = 8'h00;
            spread = 3'b000;
            cur_pwm = 3'b000;
            pwm_code = 4'h0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 0;
            pwm_code = 4'hF;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(2'b00, new_pwm);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            pwm_code = 4'h0;
            pwm_cycle = 8'hFF;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(2'b00, new_pwm);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            pwm_code = 4'h8;
            pwm_cycle = 8'h20;
            cur_pwm = 3'b001;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(mot, new_pwm);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            pwm_code = 4'hF;
            pwm_cycle = 8'hFF;
            pwm_delay = 3'b111;
            spread = 3'b111;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(mot, new_pwm);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            spread = 3'b101;
            pwm_code = 4'h4;
            pwm_cycle = 8'h40;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(mot, new_pwm);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            pre_first = 1;
            pwm_code = 4'h2;
            repeat(5) @(posedge clk);
            pre_first = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(mot, new_pwm);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            en = 1;
            pwm_delay = 3'b011;
            pwm_code = 4'hA;
            repeat(32) @(posedge clk);
            #1;

            check_outputs(mot, new_pwm);
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
        input [1:0] expected_mot;
        input [2:0] expected_new_pwm;
        begin
            if (expected_mot === (expected_mot ^ mot ^ expected_mot) &&
                expected_new_pwm === (expected_new_pwm ^ new_pwm ^ expected_new_pwm)) begin
                $display("PASS");
                $display("  Outputs: mot=%h, new_pwm=%h",
                         mot, new_pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mot=%h, new_pwm=%h",
                         expected_mot, expected_new_pwm);
                $display("  Got:      mot=%h, new_pwm=%h",
                         mot, new_pwm);
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
        $dumpvars(0,clk, cur_pwm, en, pre_first, pwm_code, pwm_cycle, pwm_delay, spread, mot, new_pwm);
    end

endmodule
