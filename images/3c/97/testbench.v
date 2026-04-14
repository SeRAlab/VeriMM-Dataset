`timescale 1ns/1ps

module RRT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] step_size;
    reg [7:0] target_x;
    reg [7:0] target_y;
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] next_x;
    wire [7:0] next_y;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT dut (
        .clk(clk),
        .reset(reset),
        .step_size(step_size),
        .target_x(target_x),
        .target_y(target_y),
        .x(x),
        .y(y),
        .next_x(next_x),
        .next_y(next_y),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            step_size = 0;
            target_x = 0;
            target_y = 0;
            x = 0;
            y = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Moving Right", test_num);
            reset_dut();
            x = 8'd10;
            y = 8'd50;
            target_x = 8'd100;
            target_y = 8'd50;
            step_size = 8'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd30, 8'd50, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Moving Up", test_num);
            reset_dut();
            x = 8'd20;
            y = 8'd20;
            target_x = 8'd20;
            target_y = 8'd80;
            step_size = 8'd15;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd20, 8'd35, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reach Target (Target within step_size)", test_num);
            reset_dut();
            x = 8'd40;
            y = 8'd40;
            target_x = 8'd45;
            target_y = 8'd45;
            step_size = 8'd20;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'd45, 8'd45, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Already at Target", test_num);
            reset_dut();
            x = 8'd100;
            y = 8'd100;
            target_x = 8'd100;
            target_y = 8'd100;
            step_size = 8'd10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd100, 8'd100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Moving Left", test_num);
            reset_dut();
            x = 8'd200;
            y = 8'd100;
            target_x = 8'd50;
            target_y = 8'd100;
            step_size = 8'd50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd150, 8'd100, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Diagonal Move Towards Target", test_num);
            reset_dut();
            x = 8'd0;
            y = 8'd0;
            target_x = 8'd100;
            target_y = 8'd100;
            step_size = 8'd10;
            @(posedge clk);
            #1;






            #1;







            check_outputs(8'd10, 8'd10, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT Testbench");
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
        input [7:0] expected_next_x;
        input [7:0] expected_next_y;
        input expected_state;
        begin
            if (expected_next_x === (expected_next_x ^ next_x ^ expected_next_x) &&
                expected_next_y === (expected_next_y ^ next_y ^ expected_next_y) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: next_x=%h, next_y=%h, state=%b",
                         next_x, next_y, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_x=%h, next_y=%h, state=%b",
                         expected_next_x, expected_next_y, expected_state);
                $display("  Got:      next_x=%h, next_y=%h, state=%b",
                         next_x, next_y, state);
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
        $dumpvars(0,clk, reset, step_size, target_x, target_y, x, y, next_x, next_y, state);
    end

endmodule
