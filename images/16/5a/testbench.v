`timescale 1ns/1ps

module SLAM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command;
    reg rst;
    wire [7:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM dut (
        .clk(clk),
        .command(command),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            command = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move Right", test_num);
            reset_dut();
            command = 2'b11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd1, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move Up", test_num);
            reset_dut();
            command = 2'b00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence (R, R, U)", test_num);
            reset_dut();
            command = 2'b11; @(posedge clk);
            command = 2'b11; @(posedge clk);
            command = 2'b00; @(posedge clk);
            #1 #1;
 check_outputs(8'd2, 8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Square Path (R, U, L, D)", test_num);
            reset_dut();
            command = 2'b11; @(posedge clk);
            command = 2'b00; @(posedge clk);
            command = 2'b10; @(posedge clk);
            command = 2'b01; @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap Around (Left)", test_num);
            reset_dut();
            command = 2'b10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap Around (Down)", test_num);
            reset_dut();
            command = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 5 steps Right, 3 steps Up", test_num);
            reset_dut();
            command = 2'b11;
            for(i=0; i<5; i=i+1) @(posedge clk);
            command = 2'b00;
            for(i=0; i<3; i=i+1) @(posedge clk);
            #1 #1;
 check_outputs(8'd5, 8'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zigzag path", test_num);
            reset_dut();
            command = 2'b11; @(posedge clk);
            command = 2'b00; @(posedge clk);
            command = 2'b11; @(posedge clk);
            command = 2'b00; @(posedge clk);
            command = 2'b10; @(posedge clk);
            command = 2'b01; @(posedge clk);
            #1 #1;
 check_outputs(8'd1, 8'd1);
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
        input [7:0] expected_x;
        input [7:0] expected_y;
        begin
            if (expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: x=%h, y=%h",
                         x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h, y=%h",
                         expected_x, expected_y);
                $display("  Got:      x=%h, y=%h",
                         x, y);
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
        $dumpvars(0,clk, command, rst, x, y);
    end

endmodule
