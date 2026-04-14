`timescale 1ns/1ps

module rrt_stepper_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_x;
    reg [7:0] current_y;
    reg reset;
    reg [3:0] step_size;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire [7:0] next_x;
    wire [7:0] next_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_stepper dut (
        .clk(clk),
        .current_x(current_x),
        .current_y(current_y),
        .reset(reset),
        .step_size(step_size),
        .target_x(target_x),
        .target_y(target_y),
        .next_x(next_x),
        .next_y(next_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            current_x = 0;
            current_y = 0;
            target_x = 0;
            target_y = 0;
            step_size = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Positive movement X and Y", test_num);
            current_x = 8'd10;
            current_y = 8'd10;
            target_x = 8'd50;
            target_y = 8'd50;
            step_size = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15, 8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Negative movement X and Y", test_num);
            current_x = 8'd100;
            current_y = 8'd100;
            target_x = 8'd50;
            target_y = 8'd50;
            step_size = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd90, 8'd90);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Overshoot clamping to target", test_num);
            current_x = 8'd20;
            current_y = 8'd20;
            target_x = 8'd22;
            target_y = 8'd22;
            step_size = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd22, 8'd22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Already at target", test_num);
            current_x = 8'd75;
            current_y = 8'd75;
            target_x = 8'd75;
            target_y = 8'd75;
            step_size = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd75, 8'd75);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Move X only", test_num);
            current_x = 8'd40;
            current_y = 8'd100;
            target_x = 8'd60;
            target_y = 8'd100;
            step_size = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd45, 8'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Move Y only negative", test_num);
            current_x = 8'd100;
            current_y = 8'd40;
            target_x = 8'd100;
            target_y = 8'd20;
            step_size = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100, 8'd33);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Boundary movement with max step", test_num);
            current_x = 8'd0;
            current_y = 8'd245;
            target_x = 8'd255;
            target_y = 8'd255;
            step_size = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15, 8'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_stepper Testbench");
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
        input [7:0] expected_next_x;
        input [7:0] expected_next_y;
        begin
            if (expected_next_x === (expected_next_x ^ next_x ^ expected_next_x) &&
                expected_next_y === (expected_next_y ^ next_y ^ expected_next_y)) begin
                $display("PASS");
                $display("  Outputs: next_x=%h, next_y=%h",
                         next_x, next_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_x=%h, next_y=%h",
                         expected_next_x, expected_next_y);
                $display("  Got:      next_x=%h, next_y=%h",
                         next_x, next_y);
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
        $dumpvars(0,clk, current_x, current_y, reset, step_size, target_x, target_y, next_x, next_y);
    end

endmodule
