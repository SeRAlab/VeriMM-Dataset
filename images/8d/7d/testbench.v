`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg CLOCK;
    reg RESET;
    wire COUNT_ENABLE;
    wire DIRECTION;
    wire [3:0] SPEED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLOCK(CLOCK),
        .RESET(RESET),
        .COUNT_ENABLE(COUNT_ENABLE),
        .DIRECTION(DIRECTION),
        .SPEED(SPEED)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            RESET = 1;
            A = 0;
            B = 0;
            enc_state = 2'b00;
            repeat(2) @(posedge CLOCK);
            #1 RESET = 0;
            repeat(1) @(posedge CLOCK);
            #1;
        end
        endtask
    task step_fw;

        begin
            case (enc_state)
                2'b00: enc_state = 2'b10;
                2'b10: enc_state = 2'b11;
                2'b11: enc_state = 2'b01;
                2'b01: enc_state = 2'b00;
            endcase
            A = enc_state[1];
            B = enc_state[0];
            @(posedge CLOCK);
            #2;
        end
        endtask

    task step_bw;

        begin
            case (enc_state)
                2'b00: enc_state = 2'b01;
                2'b01: enc_state = 2'b11;
                2'b11: enc_state = 2'b10;
                2'b10: enc_state = 2'b00;
            endcase
            A = enc_state[1];
            B = enc_state[0];
            @(posedge CLOCK);
            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset state check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Forward 10 steps (Level 0)", test_num);
            reset_dut();
            repeat(10) step_fw();
            #1;

            check_outputs(1'b0, 1'b1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Forward 40 steps (Level 1)", test_num);
            reset_dut();
            repeat(40) step_fw();
            #1;

            check_outputs(1'b0, 1'b1, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Forward 70 steps (Level 2)", test_num);
            reset_dut();
            repeat(70) step_fw();
            #1;

            check_outputs(1'b0, 1'b1, 4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Forward 100 steps (Level 3)", test_num);
            reset_dut();
            repeat(100) step_fw();
            #1;

            check_outputs(1'b0, 1'b1, 4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Forward 120 steps (Saturation at 109, Level 3)", test_num);
            reset_dut();
            repeat(120) step_fw();
            #1;

            check_outputs(1'b0, 1'b1, 4'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Forward 100 steps then Backward 40 steps (Pos 60, Level 2)", test_num);
            reset_dut();
            repeat(100) step_fw();
            repeat(40) step_bw();
            #1;

            check_outputs(1'b0, 1'b0, 4'h2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Backward 20 steps from reset (Saturation at 0, Level 0)", test_num);
            reset_dut();
            repeat(20) step_bw();
            #1;

            check_outputs(1'b0, 1'b0, 4'h0);
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
        input expected_COUNT_ENABLE;
        input expected_DIRECTION;
        input [3:0] expected_SPEED;
        begin
            if (expected_COUNT_ENABLE === (expected_COUNT_ENABLE ^ COUNT_ENABLE ^ expected_COUNT_ENABLE) &&
                expected_DIRECTION === (expected_DIRECTION ^ DIRECTION ^ expected_DIRECTION) &&
                expected_SPEED === (expected_SPEED ^ SPEED ^ expected_SPEED)) begin
                $display("PASS");
                $display("  Outputs: COUNT_ENABLE=%b, DIRECTION=%b, SPEED=%h",
                         COUNT_ENABLE, DIRECTION, SPEED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT_ENABLE=%b, DIRECTION=%b, SPEED=%h",
                         expected_COUNT_ENABLE, expected_DIRECTION, expected_SPEED);
                $display("  Got:      COUNT_ENABLE=%b, DIRECTION=%b, SPEED=%h",
                         COUNT_ENABLE, DIRECTION, SPEED);
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
        $dumpvars(0,A, B, CLOCK, RESET, COUNT_ENABLE, DIRECTION, SPEED);
    end

endmodule
