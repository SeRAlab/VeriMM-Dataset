`timescale 1ns/1ps

module rrt_step_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_x;
    reg [7:0] current_y;
    reg [7:0] goal_x;
    reg [7:0] goal_y;
    reg [255:0] obstacle_map;
    reg rst;
    wire [7:0] new_x;
    wire [7:0] new_y;
    wire reached;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_step dut (
        .clk(clk),
        .current_x(current_x),
        .current_y(current_y),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .obstacle_map(obstacle_map),
        .rst(rst),
        .new_x(new_x),
        .new_y(new_y),
        .reached(reached),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_x = 8'd0;
            current_y = 8'd0;
            goal_x = 8'd0;
            goal_y = 8'd0;
            obstacle_map = 256'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            current_x = 8'd2;
            current_y = 8'd2;
            goal_x = 8'd10;
            goal_y = 8'd10;
            obstacle_map = 256'h0;

            @(posedge clk);
            #2;



            #1;




            check_outputs(8'd3, 8'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            current_x = 8'd9;
            current_y = 8'd9;
            goal_x = 8'd10;
            goal_y = 8'd10;
            obstacle_map = 256'h0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd10, 8'd10, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            current_x = 8'd5;
            current_y = 8'd5;
            goal_x = 8'd10;
            goal_y = 8'd10;
            obstacle_map = (256'b1 << 102);

            @(posedge clk);
            #2;



            #1;




            check_outputs(8'd6, 8'd6, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            current_x = 8'd2;
            current_y = 8'd5;
            goal_x = 8'd10;
            goal_y = 8'd5;
            obstacle_map = 256'h0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd3, 8'd5, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            current_x = 8'd14;
            current_y = 8'd14;
            goal_x = 8'd15;
            goal_y = 8'd15;
            obstacle_map = 256'h0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd15, 8'd15, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            current_x = 8'd5;
            current_y = 8'd5;
            goal_x = 8'd8;
            goal_y = 8'd8;

            @(posedge clk);
            rst = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'd0, 8'd0, 1'b0, 1'b0);
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
        input expected_reached;
        input expected_valid;
        begin
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x) &&
                expected_new_y === (expected_new_y ^ new_y ^ expected_new_y) &&
                expected_reached === (expected_reached ^ reached ^ expected_reached) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h, new_y=%h, reached=%b, valid=%b",
                         new_x, new_y, reached, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h, new_y=%h, reached=%b, valid=%b",
                         expected_new_x, expected_new_y, expected_reached, expected_valid);
                $display("  Got:      new_x=%h, new_y=%h, reached=%b, valid=%b",
                         new_x, new_y, reached, valid);
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
        $dumpvars(0,clk, current_x, current_y, goal_x, goal_y, obstacle_map, rst, new_x, new_y, reached, valid);
    end

endmodule
