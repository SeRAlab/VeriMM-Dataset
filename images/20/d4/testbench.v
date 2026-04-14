`timescale 1ns/1ps

module SLAM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command;
    reg reset;
    wire [3:0] pos_x;
    wire [3:0] pos_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM dut (
        .clk(clk),
        .command(command),
        .reset(reset),
        .pos_x(pos_x),
        .pos_y(pos_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        command = 2'b00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic Movement (Right, Up)", test_num);
        reset_dut();


        command = CMD_RIGHT; @(posedge clk);

        command = CMD_UP; @(posedge clk);

        #1 #1;
 check_outputs(4'h1, 4'h1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Multiple steps Right", test_num);
        reset_dut();

        command = CMD_RIGHT;
        repeat(5) @(posedge clk);

        #1 #1;
 check_outputs(4'h5, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Square path (R, U, L, D)", test_num);
        reset_dut();

        command = CMD_RIGHT; @(posedge clk);
        command = CMD_UP;    @(posedge clk);
        command = CMD_LEFT;  @(posedge clk);
        command = CMD_DOWN;  @(posedge clk);

        #1 #1;
 check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Zig-zag movement", test_num);
        reset_dut();

        repeat(3) begin
            command = CMD_RIGHT; @(posedge clk);
            command = CMD_UP;    @(posedge clk);
        end

        #1 #1;
 check_outputs(4'h3, 4'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Moving to far corner", test_num);
        reset_dut();

        command = CMD_RIGHT; repeat(10) @(posedge clk);
        command = CMD_UP;    repeat(12) @(posedge clk);

        #1 #1;
 check_outputs(4'hA, 4'hC);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Reset behavior mid-operation", test_num);
        reset_dut();

        command = CMD_RIGHT; repeat(5) @(posedge clk);
        command = CMD_UP;    repeat(5) @(posedge clk);


        reset = 1; @(posedge clk);
        reset = 0; @(posedge clk);

        #1 #1;
 check_outputs(4'h0, 4'h0);
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
        input [3:0] expected_pos_x;
        input [3:0] expected_pos_y;
        begin
            if (expected_pos_x === (expected_pos_x ^ pos_x ^ expected_pos_x) &&
                expected_pos_y === (expected_pos_y ^ pos_y ^ expected_pos_y)) begin
                $display("PASS");
                $display("  Outputs: pos_x=%h, pos_y=%h",
                         pos_x, pos_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos_x=%h, pos_y=%h",
                         expected_pos_x, expected_pos_y);
                $display("  Got:      pos_x=%h, pos_y=%h",
                         pos_x, pos_y);
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
        $dumpvars(0,clk, command, reset, pos_x, pos_y);
    end

endmodule
