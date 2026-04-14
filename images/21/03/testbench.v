`timescale 1ns/1ps

module SLAM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg reset;
    wire [15:0] visited;
    wire [3:0] x_pos;
    wire [3:0] y_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM dut (
        .clk(clk),
        .direction(direction),
        .reset(reset),
        .visited(visited),
        .x_pos(x_pos),
        .y_pos(y_pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            direction = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic movement (Right, Up)");
            reset_dut();

            direction = 2'b11;
            @(posedge clk);
            direction = 2'b00;
            @(posedge clk);



            #1;




            check_outputs(16'h0023, 4'h1, 4'h1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Square path (R, U, L, D)");
            reset_dut();

            direction = 2'b11;
            @(posedge clk);
            direction = 2'b00;
            @(posedge clk);
            direction = 2'b10;
            @(posedge clk);
            direction = 2'b01;
            @(posedge clk);



            #1;




            check_outputs(16'h0033, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Boundary check (Min bounds)");
            reset_dut();

            direction = 2'b10;
            @(posedge clk);
            direction = 2'b01;
            @(posedge clk);


            #1;



            check_outputs(16'h0001, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary check (Max bounds)");
            reset_dut();


            direction = 2'b11;
            repeat(4) @(posedge clk);


            direction = 2'b00;
            repeat(4) @(posedge clk);





            #1;






            check_outputs(16'h888F, 4'h3, 4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Coverage path");
            reset_dut();

            direction = 2'b11;
            repeat(3) @(posedge clk);
            direction = 2'b00;
            @(posedge clk);
            direction = 2'b10;
            repeat(3) @(posedge clk);




            #1;





            check_outputs(16'h00FF, 4'h0, 4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM Testbench");
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
        input [15:0] expected_visited;
        input [3:0] expected_x_pos;
        input [3:0] expected_y_pos;
        begin
            if (expected_visited === (expected_visited ^ visited ^ expected_visited) &&
                expected_x_pos === (expected_x_pos ^ x_pos ^ expected_x_pos) &&
                expected_y_pos === (expected_y_pos ^ y_pos ^ expected_y_pos)) begin
                $display("PASS");
                $display("  Outputs: visited=%h, x_pos=%h, y_pos=%h",
                         visited, x_pos, y_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: visited=%h, x_pos=%h, y_pos=%h",
                         expected_visited, expected_x_pos, expected_y_pos);
                $display("  Got:      visited=%h, x_pos=%h, y_pos=%h",
                         visited, x_pos, y_pos);
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
        $dumpvars(0,clk, direction, reset, visited, x_pos, y_pos);
    end

endmodule
