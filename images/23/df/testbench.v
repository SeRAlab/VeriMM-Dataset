`timescale 1ns/1ps

module rrt_core_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] random_x;
    reg [7:0] random_y;
    reg reset;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire [7:0] new_x;
    wire [7:0] new_y;
    wire reached_target;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_core dut (
        .clk(clk),
        .random_x(random_x),
        .random_y(random_y),
        .reset(reset),
        .target_x(target_x),
        .target_y(target_y),
        .new_x(new_x),
        .new_y(new_y),
        .reached_target(reached_target)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            random_x = 0;
            random_y = 0;
            target_x = 0;
            target_y = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(new_x, new_y, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Direct Target Sampling", test_num);
            reset_dut();

            target_x = 8'd100;
            target_y = 8'd100;
            random_x = 8'd100;
            random_y = 8'd100;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(new_x, new_y, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Single Step Expansion", test_num);
            reset_dut();

            target_x = 8'd200;
            target_y = 8'd200;
            random_x = 8'd50;
            random_y = 8'd50;

            repeat(5) @(posedge clk);


            if (reached_target === 1'b0 && (new_x != 0 || new_y != 0)) begin
                pass_count = pass_count + 1;
                $display("PASS: Point generated, target not reached.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Logic error in expansion.");
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test Case %0d: Iterative Growth", test_num);
            reset_dut();

            target_x = 8'd40;
            target_y = 8'd40;


            for (i = 10; i <= 40; i = i + 10) begin
                random_x = i;
                random_y = i;
                repeat(5) @(posedge clk);
            end


            #1;



            check_outputs(new_x, new_y, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Maximum Coordinate Limits", test_num);
            reset_dut();

            target_x = 8'hFF;
            target_y = 8'hFF;
            random_x = 8'hFF;
            random_y = 8'hFF;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'hFF, 8'hFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_core Testbench");
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
        input [7:0] expected_new_x;
        input [7:0] expected_new_y;
        input expected_reached_target;
        begin
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x) &&
                expected_new_y === (expected_new_y ^ new_y ^ expected_new_y) &&
                expected_reached_target === (expected_reached_target ^ reached_target ^ expected_reached_target)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h, new_y=%h, reached_target=%b",
                         new_x, new_y, reached_target);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h, new_y=%h, reached_target=%b",
                         expected_new_x, expected_new_y, expected_reached_target);
                $display("  Got:      new_x=%h, new_y=%h, reached_target=%b",
                         new_x, new_y, reached_target);
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
        $dumpvars(0,clk, random_x, random_y, reset, target_x, target_y, new_x, new_y, reached_target);
    end

endmodule
