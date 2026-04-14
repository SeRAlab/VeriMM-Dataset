`timescale 1ns/1ps

module slam_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg [1:0] distance;
    reg rst;
    wire [7:0] pos_x;
    wire [7:0] pos_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam dut (
        .clk(clk),
        .direction(direction),
        .distance(distance),
        .rst(rst),
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
            rst = 1;
            direction = 0;
            distance = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Single Move North", test_num);
            reset_dut();
            direction = 2'b00;
            distance  = 2'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Single Move East", test_num);
            reset_dut();
            direction = 2'b01;
            distance  = 2'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Single Move South (Negative Y)", test_num);
            reset_dut();
            direction = 2'b10;
            distance  = 2'd1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Single Move West (Negative X)", test_num);
            reset_dut();
            direction = 2'b11;
            distance  = 2'd2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFE, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Multiple Moves (Pathing)", test_num);
            reset_dut();


            direction = 2'b00; distance = 2'd3; @(posedge clk); #1;

            direction = 2'b01; distance = 2'd2; @(posedge clk); #1;

            direction = 2'b10; distance = 2'd1; @(posedge clk); #1;


            #1;



            check_outputs(8'h02, 8'h02);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Circular Path (Return to Origin)", test_num);
            reset_dut();

            direction = 2'b00; distance = 2'd2; @(posedge clk); #1;
            direction = 2'b01; distance = 2'd2; @(posedge clk); #1;
            direction = 2'b10; distance = 2'd2; @(posedge clk); #1;
            direction = 2'b11; distance = 2'd2; @(posedge clk); #1;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Maximum Distance Steps", test_num);
            reset_dut();

            direction = 2'b00; distance = 2'd3;
            repeat(4) begin @(posedge clk); #1; end

            direction = 2'b11; distance = 2'd3;
            repeat(2) begin @(posedge clk); #1; end


            #1;



            check_outputs(8'hFA, 8'h0C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam Testbench");
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
        input [7:0] expected_pos_x;
        input [7:0] expected_pos_y;
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
        $dumpvars(0,clk, direction, distance, rst, pos_x, pos_y);
    end

endmodule
