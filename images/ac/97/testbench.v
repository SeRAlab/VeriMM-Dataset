`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Lose;
    reg RESET;
    reg START;
    reg [31:0] clkdiv;
    reg fly_button;
    reg fresh;
    reg game_status;
    reg [9:0] x;
    reg [8:0] y;
    wire [8:0] bird_y;
    wire is_bird;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Lose(Lose),
        .RESET(RESET),
        .START(START),
        .clkdiv(clkdiv),
        .fly_button(fly_button),
        .fresh(fresh),
        .game_status(game_status),
        .x(x),
        .y(y),
        .bird_y(bird_y),
        .is_bird(is_bird)
    );

    // Clock generation (10ns period)
    initial begin
        clkdiv = 0;
        forever #5 clkdiv = ~clkdiv;
    end

        task reset_dut;

        begin
            RESET = 1;
            START = 0;
            Lose = 0;
            fly_button = 0;
            fresh = 0;
            game_status = 0;
            x = 0;
            y = 0;
            repeat (5) @(posedge clkdiv[0]);
            RESET = 0;
            repeat (2) @(posedge clkdiv[0]);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();


            #1;



            check_outputs(9'd200, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Gravity Effect Check", test_num);
            reset_dut();
            START = 1;
            game_status = 1;


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clkdiv[0]);
                fresh = 1;
                @(posedge clkdiv[0]);
                fresh = 0;
                repeat (2) @(posedge clkdiv[0]);
            end



            if (bird_y > 9'd200)
                #1;

                check_outputs(bird_y, 1'b0);
            else
                #1;

                check_outputs(9'd210, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fly Button Check", test_num);
            reset_dut();
            START = 1;
            game_status = 1;
            fly_button = 1;


            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clkdiv[0]);
                fresh = 1;
                @(posedge clkdiv[0]);
                fresh = 0;
                repeat (2) @(posedge clkdiv[0]);
            end


            if (bird_y < 9'd200)
                #1;

                check_outputs(bird_y, 1'b0);
            else
                #1;

                check_outputs(9'd190, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Coordinate Visibility Check", test_num);
            reset_dut();




            x = 10'd100;
            y = 9'd200;

            #20;

            #1;


            check_outputs(bird_y, 1'b1);
        end
        endtask

    task testcase005;

        reg [8:0] captured_y;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lose Condition Check", test_num);
            reset_dut();
            START = 1;
            game_status = 1;
            Lose = 1;

            @(posedge clkdiv[0]);
            captured_y = bird_y;


            @(posedge clkdiv[0]);
            fresh = 1;
            @(posedge clkdiv[0]);
            fresh = 0;


            #1;



            check_outputs(captured_y, 1'b0);
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
        input [8:0] expected_bird_y;
        input expected_is_bird;
        begin
            if (expected_bird_y === (expected_bird_y ^ bird_y ^ expected_bird_y) &&
                expected_is_bird === (expected_is_bird ^ is_bird ^ expected_is_bird)) begin
                $display("PASS");
                $display("  Outputs: bird_y=%h, is_bird=%b",
                         bird_y, is_bird);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bird_y=%h, is_bird=%b",
                         expected_bird_y, expected_is_bird);
                $display("  Got:      bird_y=%h, is_bird=%b",
                         bird_y, is_bird);
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
        $dumpvars(0,Lose, RESET, START, clkdiv, fly_button, fresh, game_status, x, y, bird_y, is_bird);
    end

endmodule
