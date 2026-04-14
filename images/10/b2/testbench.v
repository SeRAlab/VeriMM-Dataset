`timescale 1ns/1ps

module RRT_Node_Manager_tb;

    // Testbench signals (sequential circuit)
    reg add_node;
    reg clk;
    reg random_walk;
    reg rst;
    reg [7:0] x_in;
    reg [7:0] y_in;
    wire [7:0] last_x;
    wire [7:0] last_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT_Node_Manager dut (
        .add_node(add_node),
        .clk(clk),
        .random_walk(random_walk),
        .rst(rst),
        .x_in(x_in),
        .y_in(y_in),
        .last_x(last_x),
        .last_y(last_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            add_node = 0;
            random_walk = 0;
            x_in = 8'h0;
            y_in = 8'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic Add Node");
            reset_dut();
            x_in = 8'h10;
            y_in = 8'h20;
            add_node = 1;
            @(posedge clk);
            #1 add_node = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h10, 8'h20);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Maximum Boundary Values");
            reset_dut();
            x_in = 8'hFF;
            y_in = 8'hFF;
            add_node = 1;
            @(posedge clk);
            #1 add_node = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Sequential Node Addition (Overwrite)");
            reset_dut();

            x_in = 8'hAA;
            y_in = 8'h55;
            add_node = 1;
            @(posedge clk);
            #1;

            x_in = 8'h12;
            y_in = 8'h34;
            @(posedge clk);
            #1 add_node = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h12, 8'h34);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Data Persistence (add_node=0)");
            reset_dut();
            x_in = 8'h50;
            y_in = 8'h60;
            add_node = 1;
            @(posedge clk);
            #1 add_node = 0;
            x_in = 8'hZZ;
            y_in = 8'hZZ;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(8'h50, 8'h60);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Reset mid-operation");
            reset_dut();
            x_in = 8'h88;
            y_in = 8'h99;
            add_node = 1;
            @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Random Walk Trigger");
            reset_dut();

            x_in = 8'd100;
            y_in = 8'd100;
            add_node = 1;
            @(posedge clk);
            #1 add_node = 0;

            random_walk = 1;
            @(posedge clk);
            #1 random_walk = 0;
            @(posedge clk);




            $display("  Info: random_walk result x=%h, y=%h", last_x, last_y);
            if (last_x !== 8'hxx && last_y !== 8'hxx) begin
                pass_count = pass_count + 1;
                $display("  PASS: Walk executed without generating X");
            end else begin
                fail_count = fail_count + 1;
                $display("  FAIL: Walk generated invalid state");
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT_Node_Manager Testbench");
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
        input [7:0] expected_last_x;
        input [7:0] expected_last_y;
        begin
            if (expected_last_x === (expected_last_x ^ last_x ^ expected_last_x) &&
                expected_last_y === (expected_last_y ^ last_y ^ expected_last_y)) begin
                $display("PASS");
                $display("  Outputs: last_x=%h, last_y=%h",
                         last_x, last_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: last_x=%h, last_y=%h",
                         expected_last_x, expected_last_y);
                $display("  Got:      last_x=%h, last_y=%h",
                         last_x, last_y);
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
        $dumpvars(0,add_node, clk, random_walk, rst, x_in, y_in, last_x, last_y);
    end

endmodule
