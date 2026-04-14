`timescale 1ns/1ps

module rrt_step_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_x;
    reg [7:0] current_y;
    reg reset;
    reg [7:0] step_size;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire [7:0] next_x;
    wire [7:0] next_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_step dut (
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target is current position", test_num);
            reset_dut();
            current_x = 8'd50;
            current_y = 8'd50;
            target_x = 8'd50;
            target_y = 8'd50;
            step_size = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd50, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target within step size (Positive)", test_num);
            reset_dut();
            current_x = 8'd10;
            current_y = 8'd10;
            target_x = 8'd15;
            target_y = 8'd18;
            step_size = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15, 8'd18);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target beyond step size (Positive)", test_num);
            reset_dut();
            current_x = 8'd100;
            current_y = 8'd100;
            target_x = 8'd150;
            target_y = 8'd200;
            step_size = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd120, 8'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target beyond step size (Negative)", test_num);
            reset_dut();
            current_x = 8'd100;
            current_y = 8'd100;
            target_x = 8'd50;
            target_y = 8'd50;
            step_size = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd85, 8'd85);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed movement (X near, Y far)", test_num);
            reset_dut();
            current_x = 8'd40;
            current_y = 8'd40;
            target_x = 8'd42;
            target_y = 8'd100;
            step_size = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd42, 8'd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero step size", test_num);
            reset_dut();
            current_x = 8'd128;
            current_y = 8'd128;
            target_x = 8'd255;
            target_y = 8'd255;
            step_size = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd128, 8'd128);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary limits (Moving to 255)", test_num);
            reset_dut();
            current_x = 8'd250;
            current_y = 8'd250;
            target_x = 8'd255;
            target_y = 8'd255;
            step_size = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255, 8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large step size to origin", test_num);
            reset_dut();
            current_x = 8'd5;
            current_y = 8'd5;
            target_x = 8'd0;
            target_y = 8'd0;
            step_size = 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_step Testbench");
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
