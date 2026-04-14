`timescale 1ns/1ps

module rrt_node_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] max_step_size;
    reg [7:0] random_input_x;
    reg [7:0] random_input_y;
    wire [7:0] new_node_x;
    wire [7:0] new_node_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_node_generator dut (
        .clk(clk),
        .max_step_size(max_step_size),
        .random_input_x(random_input_x),
        .random_input_y(random_input_y),
        .new_node_x(new_node_x),
        .new_node_y(new_node_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            max_step_size = 8'h0;
            random_input_x = 8'h0;
            random_input_y = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Step Addition", test_num);
            reset_dut();
            max_step_size = 8'd10;
            random_input_x = 8'd50;
            random_input_y = 8'd60;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd60, 8'd70);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Input Values", test_num);
            reset_dut();
            max_step_size = 8'd5;
            random_input_x = 8'd200;
            random_input_y = 8'd150;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd205, 8'd155);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Step Size", test_num);
            reset_dut();
            max_step_size = 8'd255;
            random_input_x = 8'd0;
            random_input_y = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd255, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Step Size (No movement)", test_num);
            reset_dut();
            max_step_size = 8'd0;
            random_input_x = 8'd123;
            random_input_y = 8'd45;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd123, 8'd45);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Handling (8-bit wrap)", test_num);
            reset_dut();
            max_step_size = 8'd20;
            random_input_x = 8'd250;
            random_input_y = 8'd240;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd14, 8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Input Variation", test_num);
            reset_dut();
            max_step_size = 8'd15;
            random_input_x = 8'hA5;
            random_input_y = 8'h5A;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5 + 8'd15, 8'h5A + 8'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_node_generator Testbench");
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
        input [7:0] expected_new_node_x;
        input [7:0] expected_new_node_y;
        begin
            if (expected_new_node_x === (expected_new_node_x ^ new_node_x ^ expected_new_node_x) &&
                expected_new_node_y === (expected_new_node_y ^ new_node_y ^ expected_new_node_y)) begin
                $display("PASS");
                $display("  Outputs: new_node_x=%h, new_node_y=%h",
                         new_node_x, new_node_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_node_x=%h, new_node_y=%h",
                         expected_new_node_x, expected_new_node_y);
                $display("  Got:      new_node_x=%h, new_node_y=%h",
                         new_node_x, new_node_y);
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
        $dumpvars(0,clk, max_step_size, random_input_x, random_input_y, new_node_x, new_node_y);
    end

endmodule
