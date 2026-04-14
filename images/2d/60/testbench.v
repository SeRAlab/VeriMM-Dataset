`timescale 1ns/1ps

module robot_mapping_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg rst;
    wire [3:0] x_pos;
    wire [3:0] y_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_mapping dut (
        .clk(clk),
        .direction(direction),
        .rst(rst),
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
            rst = 1;
            direction = 2'b00;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            direction = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h1, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            direction = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            direction = 2'b11;
            @(posedge clk);
            direction = 2'b11;
            @(posedge clk);
            direction = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h2, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            direction = 2'b11;
            @(posedge clk);
            direction = 2'b00;
            @(posedge clk);
            direction = 2'b10;
            @(posedge clk);
            direction = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            direction = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(3) begin
                direction = 2'b11; @(posedge clk);
                direction = 2'b00; @(posedge clk);
            end
            #1 #1;
 check_outputs(4'h3, 4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_mapping Testbench");
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
        input [3:0] expected_x_pos;
        input [3:0] expected_y_pos;
        begin
            if (expected_x_pos === (expected_x_pos ^ x_pos ^ expected_x_pos) &&
                expected_y_pos === (expected_y_pos ^ y_pos ^ expected_y_pos)) begin
                $display("PASS");
                $display("  Outputs: x_pos=%h, y_pos=%h",
                         x_pos, y_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_pos=%h, y_pos=%h",
                         expected_x_pos, expected_y_pos);
                $display("  Got:      x_pos=%h, y_pos=%h",
                         x_pos, y_pos);
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
        $dumpvars(0,clk, direction, rst, x_pos, y_pos);
    end

endmodule
