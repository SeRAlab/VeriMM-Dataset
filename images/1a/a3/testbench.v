`timescale 1ns/1ps

module RRT_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg explore;
    reg reset;
    reg [7:0] tx;
    reg [7:0] ty;
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] new_x;
    wire [7:0] new_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT_Controller dut (
        .clk(clk),
        .explore(explore),
        .reset(reset),
        .tx(tx),
        .ty(ty),
        .x(x),
        .y(y),
        .new_x(new_x),
        .new_y(new_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            explore = 0;
            x = 0;
            y = 0;
            tx = 0;
            ty = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Move +X", test_num);
            x = 8'd50;
            y = 8'd50;
            tx = 8'd60;
            ty = 8'd50;
            explore = 1;
            @(posedge clk);
            #1 explore = 0;
            @(posedge clk);

            #1;


            check_outputs(8'd51, 8'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Move -X", test_num);
            x = 8'd50;
            y = 8'd50;
            tx = 8'd40;
            ty = 8'd50;
            explore = 1;
            @(posedge clk);
            #1 explore = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd49, 8'd50);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Move +Y", test_num);
            x = 8'd100;
            y = 8'd100;
            tx = 8'd100;
            ty = 8'd110;
            explore = 1;
            @(posedge clk);
            #1 explore = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd100, 8'd101);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Move -Y", test_num);
            x = 8'd100;
            y = 8'd100;
            tx = 8'd100;
            ty = 8'd90;
            explore = 1;
            @(posedge clk);
            #1 explore = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd100, 8'd99);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Diagonal Move", test_num);
            x = 8'd10;
            y = 8'd10;
            tx = 8'd20;
            ty = 8'd20;
            explore = 1;
            @(posedge clk);
            #1 explore = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd11, 8'd11);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Target Reached", test_num);
            x = 8'd25;
            y = 8'd25;
            tx = 8'd25;
            ty = 8'd25;
            explore = 1;
            @(posedge clk);
            #1 explore = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd25, 8'd25);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Origin Boundary", test_num);
            x = 8'd0;
            y = 8'd0;
            tx = 8'd5;
            ty = 8'd5;
            explore = 1;
            @(posedge clk);
            #1 explore = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd1, 8'd1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running Testcase %0d: Max Boundary", test_num);
            x = 8'd255;
            y = 8'd255;
            tx = 8'd250;
            ty = 8'd250;
            explore = 1;
            @(posedge clk);
            #1 explore = 0;
            @(posedge clk);
            #1;

            check_outputs(8'd254, 8'd254);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT_Controller Testbench");
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
        input [7:0] expected_new_x;
        input [7:0] expected_new_y;
        begin
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x) &&
                expected_new_y === (expected_new_y ^ new_y ^ expected_new_y)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h, new_y=%h",
                         new_x, new_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h, new_y=%h",
                         expected_new_x, expected_new_y);
                $display("  Got:      new_x=%h, new_y=%h",
                         new_x, new_y);
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
        $dumpvars(0,clk, explore, reset, tx, ty, x, y, new_x, new_y);
    end

endmodule
