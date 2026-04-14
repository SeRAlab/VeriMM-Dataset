`timescale 1ns/1ps

module RRT_Node_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] x_in;
    reg [7:0] y_in;
    wire [7:0] x_out;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT_Node dut (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        x_in = 8'h00;
        y_in = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Basic coordinate update (10, 20)", test_num);
        reset_dut();
        x_in = 8'd10;
        y_in = 8'd20;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10, 8'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Maximum coordinate values (255, 255)", test_num);
        reset_dut();
        x_in = 8'hFF;
        y_in = 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Multiple sequential updates", test_num);
        reset_dut();

        x_in = 8'd50; y_in = 8'd60;
        @(posedge clk);
        #1;

        x_in = 8'd128; y_in = 8'd128;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd128, 8'd128);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Reset override during operation", test_num);
        reset_dut();
        x_in = 8'd100; y_in = 8'd100;
        @(posedge clk);
        #1;
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest %0d: Update to zero coordinates", test_num);
        reset_dut();

        x_in = 8'hAA; y_in = 8'h55;
        @(posedge clk);
        #1;

        x_in = 8'h00; y_in = 8'h00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT_Node Testbench");
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
        input [7:0] expected_x_out;
        input [7:0] expected_y_out;
        begin
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h, y_out=%h",
                         x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h, y_out=%h",
                         expected_x_out, expected_y_out);
                $display("  Got:      x_out=%h, y_out=%h",
                         x_out, y_out);
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
        $dumpvars(0,clk, reset, x_in, y_in, x_out, y_out);
    end

endmodule
