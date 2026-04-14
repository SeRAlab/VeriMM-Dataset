`timescale 1ns/1ps

module RRTNode_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] parent_index;
    reg [4:0] position_x;
    reg [4:0] position_y;
    reg reset;
    reg set_node;
    wire [3:0] out_parent_index;
    wire [4:0] out_position_x;
    wire [4:0] out_position_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRTNode dut (
        .clk(clk),
        .parent_index(parent_index),
        .position_x(position_x),
        .position_y(position_y),
        .reset(reset),
        .set_node(set_node),
        .out_parent_index(out_parent_index),
        .out_position_x(out_position_x),
        .out_position_y(out_position_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        set_node = 0;
        parent_index = 0;
        position_x = 0;
        position_y = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Default Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(4'h0, 5'h0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Data Storage", test_num);
        reset_dut();

        @(posedge clk);
        parent_index = 4'hA;
        position_x = 5'h0F;
        position_y = 5'h15;
        set_node = 1;

        @(posedge clk);
        #1;
        set_node = 0;

        #1;


        check_outputs(4'hA, 5'h0F, 5'h15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Values Check", test_num);
        reset_dut();

        @(posedge clk);
        parent_index = 4'hF;
        position_x = 5'h1F;
        position_y = 5'h1F;
        set_node = 1;

        @(posedge clk);
        #1;
        set_node = 0;

        #1;


        check_outputs(4'hF, 5'h1F, 5'h1F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable Signal Check", test_num);
        reset_dut();

        @(posedge clk);
        parent_index = 4'h5;
        position_x = 5'h10;
        position_y = 5'h10;
        set_node = 0;

        @(posedge clk);
        #1;


        #1;



        check_outputs(4'h0, 5'h0, 5'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Persistence Check", test_num);
        reset_dut();


        @(posedge clk);
        parent_index = 4'h3;
        position_x = 5'h05;
        position_y = 5'h05;
        set_node = 1;
        @(posedge clk);
        #1;
        set_node = 0;


        parent_index = 4'hE;
        position_x = 5'h1A;
        position_y = 5'h1B;

        repeat(2) @(posedge clk);
        #1;


        #1;



        check_outputs(4'h3, 5'h05, 5'h05);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Update Check", test_num);
        reset_dut();


        @(posedge clk);
        parent_index = 4'h1;
        position_x = 5'h01;
        position_y = 5'h01;
        set_node = 1;
        @(posedge clk);


        parent_index = 4'h2;
        position_x = 5'h02;
        position_y = 5'h02;
        set_node = 1;
        @(posedge clk);
        #1;
        set_node = 0;


        #1;



        check_outputs(4'h2, 5'h02, 5'h02);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRTNode Testbench");
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
        input [3:0] expected_out_parent_index;
        input [4:0] expected_out_position_x;
        input [4:0] expected_out_position_y;
        begin
            if (expected_out_parent_index === (expected_out_parent_index ^ out_parent_index ^ expected_out_parent_index) &&
                expected_out_position_x === (expected_out_position_x ^ out_position_x ^ expected_out_position_x) &&
                expected_out_position_y === (expected_out_position_y ^ out_position_y ^ expected_out_position_y)) begin
                $display("PASS");
                $display("  Outputs: out_parent_index=%h, out_position_x=%h, out_position_y=%h",
                         out_parent_index, out_position_x, out_position_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_parent_index=%h, out_position_x=%h, out_position_y=%h",
                         expected_out_parent_index, expected_out_position_x, expected_out_position_y);
                $display("  Got:      out_parent_index=%h, out_position_x=%h, out_position_y=%h",
                         out_parent_index, out_position_x, out_position_y);
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
        $dumpvars(0,clk, parent_index, position_x, position_y, reset, set_node, out_parent_index, out_position_x, out_position_y);
    end

endmodule
