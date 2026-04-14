`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg pwm;
    reg step;
    wire Aminus;
    wire Aplus;
    wire pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .direction(direction),
        .pwm(pwm),
        .step(step),
        .Aminus(Aminus),
        .Aplus(Aplus),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            step = 0;
            direction = 1;
            pwm = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Incrementing one step (Direction=1)", test_num);
            reset_dut();
            direction = 1;
            pwm = 1;
            @(posedge clk);
            step = 1;
            @(posedge clk);
            step = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Incrementing two steps (Direction=1)", test_num);
            reset_dut();
            direction = 1;
            pwm = 1;

            @(posedge clk); step = 1;
            @(posedge clk); step = 0;

            @(posedge clk); step = 1;
            @(posedge clk); step = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Stepping forward then backward (Direction change)", test_num);
            reset_dut();

            direction = 1;
            pwm = 1;
            @(posedge clk); step = 1;
            @(posedge clk); step = 0;


            direction = 0;
            @(posedge clk); step = 1;
            @(posedge clk); step = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying PWM modulation output", test_num);
            reset_dut();
            direction = 1;
            pwm = 0;
            @(posedge clk);
            #1;
            if (pwm_out == 0) begin
                pwm = 1;
                #20;
                if (pwm_out == 1) begin
                    #1;

                    check_outputs(0, 1, 1);
                end else begin
                    #1;

                    check_outputs(0, 1, 1);
                end
            end else begin
                #1;

                check_outputs(0, 1, 0);
            end
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Checking wrap-around logic (4 steps)", test_num);
            reset_dut();
            direction = 1;
            pwm = 1;

            for(i=0; i<4; i=i+1) begin
                @(posedge clk); step = 1;
                @(posedge clk); step = 0;
            end
            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 1, 1);
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
        input expected_Aminus;
        input expected_Aplus;
        input expected_pwm_out;
        begin
            if (expected_Aminus === (expected_Aminus ^ Aminus ^ expected_Aminus) &&
                expected_Aplus === (expected_Aplus ^ Aplus ^ expected_Aplus) &&
                expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out)) begin
                $display("PASS");
                $display("  Outputs: Aminus=%b, Aplus=%b, pwm_out=%b",
                         Aminus, Aplus, pwm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Aminus=%b, Aplus=%b, pwm_out=%b",
                         expected_Aminus, expected_Aplus, expected_pwm_out);
                $display("  Got:      Aminus=%b, Aplus=%b, pwm_out=%b",
                         Aminus, Aplus, pwm_out);
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
        $dumpvars(0,clk, direction, pwm, step, Aminus, Aplus, pwm_out);
    end

endmodule
