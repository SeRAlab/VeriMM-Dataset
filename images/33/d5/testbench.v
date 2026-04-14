`timescale 1ns/1ps

module slam_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg move_down;
    reg move_left;
    reg move_right;
    reg move_up;
    reg reset;
    wire [7:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_system dut (
        .clk(clk),
        .move_down(move_down),
        .move_left(move_left),
        .move_right(move_right),
        .move_up(move_up),
        .reset(reset),
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
            reset = 1;
            move_up = 0;
            move_down = 0;
            move_left = 0;
            move_right = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Square path (R->U->L->D)", test_num);
            reset_dut();


            move_right = 1; @(posedge clk); #1; move_right = 0;

            move_up = 1;    @(posedge clk); #1; move_up = 0;

            move_left = 1;  @(posedge clk); #1; move_left = 0;

            move_down = 1;  @(posedge clk); #1; move_down = 0;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long distance movement (X=10, Y=5)", test_num);
            reset_dut();


            move_right = 1;
            for(i=0; i<10; i=i+1) @(posedge clk);
            #1; move_right = 0;


            move_up = 1;
            for(i=0; i<5; i=i+1) @(posedge clk);
            #1; move_up = 0;

            #1;


            check_outputs(8'd10, 8'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Underflow check (Moving Left and Down from origin)", test_num);
            reset_dut();


            move_left = 1;  @(posedge clk); #1; move_left = 0;

            move_down = 1;  @(posedge clk); #1; move_down = 0;


            #1;



            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Diagonal movement (Up + Right simultaneously)", test_num);
            reset_dut();


            move_up = 1;
            move_right = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            move_up = 0;
            move_right = 0;

            #1;


            check_outputs(8'd3, 8'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex path sequence", test_num);
            reset_dut();



            move_right = 1; @(posedge clk);
            @(posedge clk);
            @(posedge clk); #1; move_right = 0;

            move_up = 1; @(posedge clk); #1; move_up = 0;

            move_left = 1; @(posedge clk); #1; move_left = 0;

            move_up = 1; @(posedge clk); #1; move_up = 0;

            move_right = 1; @(posedge clk); #1; move_right = 0;

            #1;


            check_outputs(8'd3, 8'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset mid-operation check", test_num);
            reset_dut();


            move_right = 1; move_up = 1;
            repeat(5) @(posedge clk);
            #1; move_right = 0; move_up = 0;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;


            move_right = 1;
            @(posedge clk);
            #1;
            move_right = 0;

            #1;


            check_outputs(8'h01, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_system Testbench");
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
        $dumpvars(0,clk, move_down, move_left, move_right, move_up, reset, x, y);
    end

endmodule
