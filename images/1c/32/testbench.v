`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] end_x;
    reg [3:0] end_y;
    reg [15:0] grid;
    reg rst;
    reg [3:0] start_x;
    reg [3:0] start_y;
    wire [15:0] path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .clk(clk),
        .end_x(end_x),
        .end_y(end_y),
        .grid(grid),
        .rst(rst),
        .start_x(start_x),
        .start_y(start_y),
        .path(path)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start_x = 0;
            start_y = 0;
            end_x = 0;
            end_y = 0;
            grid = 16'h0000;
            #(clk_period * 2);
            rst = 0;
            #(clk_period);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Horizontal Path (0,0) to (3,0)", test_num);
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            end_x = 4'd3;   end_y = 4'd0;
            grid = 16'h0000;


            #(clk_period * 100);



            #1;




            check_outputs(16'h000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vertical Path (0,0) to (0,3)", test_num);
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            end_x = 4'd0;   end_y = 4'd3;
            grid = 16'h0000;

            #(clk_period * 100);



            #1;




            check_outputs(16'h1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Detour around obstacle at (1,0)", test_num);
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            end_x = 4'd2;   end_y = 4'd0;
            grid = 16'h0002;

            #(clk_period * 200);



            #1;




            check_outputs(16'h0075);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Start equals End (1,1)", test_num);
            reset_dut();
            start_x = 4'd1; start_y = 4'd1;
            end_x = 4'd1;   end_y = 4'd1;
            grid = 16'h0000;

            #(clk_period * 50);


            #1;



            check_outputs(16'h0020);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Path blocked by walls", test_num);
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            end_x = 4'd3;   end_y = 4'd3;


            grid = 16'h0012;

            #(clk_period * 200);



            #1;




            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diagonal staircase (0,0) to (2,2)", test_num);
            reset_dut();
            start_x = 4'd0; start_y = 4'd0;
            end_x = 4'd2;   end_y = 4'd2;
            grid = 16'h0000;

            #(clk_period * 200);




            #1;





            check_outputs(16'h0463);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarSearch Testbench");
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
        input [15:0] expected_path;
        begin
            if (expected_path === (expected_path ^ path ^ expected_path)) begin
                $display("PASS");
                $display("  Outputs: path=%h",
                         path);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path=%h",
                         expected_path);
                $display("  Got:      path=%h",
                         path);
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
        $dumpvars(0,clk, end_x, end_y, grid, rst, start_x, start_y, path);
    end

endmodule
