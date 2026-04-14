`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg attack_on;
    reg clk;
    reg home_on;
    reg [7:0] keyboard;
    wire video_attack_on;
    wire video_home_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .attack_on(attack_on),
        .clk(clk),
        .home_on(home_on),
        .keyboard(keyboard),
        .video_attack_on(video_attack_on),
        .video_home_on(video_home_on)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            keyboard = 8'h00;
            home_on = 0;
            attack_on = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial State 0 Verification", test_num);
            reset_dut();

            home_on = 1;
            attack_on = 1;
            repeat (2) @(posedge clk);


            #1;



            check_outputs(0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition to State 1 (CR Key)", test_num);
            reset_dut();


            keyboard = KB_CR;
            @(posedge clk);
            keyboard = 8'h00;

            home_on = 1;
            attack_on = 1;
            repeat (2) @(posedge clk);


            #1;



            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle back to State 0", test_num);
            reset_dut();


            keyboard = KB_CR;
            @(posedge clk);
            keyboard = 8'h00;
            repeat (2) @(posedge clk);


            keyboard = KB_CR;
            @(posedge clk);
            keyboard = 8'h00;

            home_on = 1;
            attack_on = 0;
            repeat (2) @(posedge clk);


            #1;



            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Non-CR key should not toggle state", test_num);
            reset_dut();


            keyboard = KB_A;
            @(posedge clk);
            keyboard = 8'h00;

            home_on = 1;
            attack_on = 1;
            repeat (2) @(posedge clk);


            #1;



            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Output transparency in State 0", test_num);
            reset_dut();

            home_on = 0;
            attack_on = 1;
            repeat (2) @(posedge clk);


            #1;



            check_outputs(0, 0);
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
        input expected_video_attack_on;
        input expected_video_home_on;
        begin
            if (expected_video_attack_on === (expected_video_attack_on ^ video_attack_on ^ expected_video_attack_on) &&
                expected_video_home_on === (expected_video_home_on ^ video_home_on ^ expected_video_home_on)) begin
                $display("PASS");
                $display("  Outputs: video_attack_on=%b, video_home_on=%b",
                         video_attack_on, video_home_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: video_attack_on=%b, video_home_on=%b",
                         expected_video_attack_on, expected_video_home_on);
                $display("  Got:      video_attack_on=%b, video_home_on=%b",
                         video_attack_on, video_home_on);
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
        $dumpvars(0,attack_on, clk, home_on, keyboard, video_attack_on, video_home_on);
    end

endmodule
