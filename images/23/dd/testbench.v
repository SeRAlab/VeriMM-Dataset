`timescale 1ns/1ps

module SLAM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg map_update;
    reg move_down;
    reg move_left;
    reg move_right;
    reg move_up;
    reg rst;
    wire [1:0] map_status;
    wire [7:0] position_x;
    wire [7:0] position_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM dut (
        .clk(clk),
        .map_update(map_update),
        .move_down(move_down),
        .move_left(move_left),
        .move_right(move_right),
        .move_up(move_up),
        .rst(rst),
        .map_status(map_status),
        .position_x(position_x),
        .position_y(position_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            map_update = 0;
            move_down = 0;
            move_left = 0;
            move_right = 0;
            move_up = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify system reset values", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move Right and Up", test_num);
            reset_dut();


            repeat(3) begin
                move_right = 1; @(posedge clk);
            end
            move_right = 0;


            repeat(2) begin
                move_up = 1; @(posedge clk);
            end
            move_up = 0;

            #1;


            check_outputs(2'b00, 8'h03, 8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move Left and Down (from origin)", test_num);
            reset_dut();


            move_left = 1; @(posedge clk);
            move_left = 0;


            repeat(5) begin
                move_down = 1; @(posedge clk);
            end
            move_down = 0;

            #1;


            check_outputs(2'b00, 8'hFF, 8'hFB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trigger Map Update", test_num);
            reset_dut();


            move_right = 1; move_up = 1;
            @(posedge clk);
            move_right = 0; move_up = 0;


            map_update = 1;
            @(posedge clk);
            map_update = 0;
            @(posedge clk);


            #1;



            check_outputs(2'b01, 8'h01, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move in a square path back to origin", test_num);
            reset_dut();

            repeat(2) begin move_right = 1; @(posedge clk); end move_right = 0;
            repeat(2) begin move_up = 1;    @(posedge clk); end move_up = 0;
            repeat(2) begin move_left = 1;  @(posedge clk); end move_left = 0;
            repeat(2) begin move_down = 1;  @(posedge clk); end move_down = 0;

            #1;


            check_outputs(2'b00, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Perform multiple map updates", test_num);
            reset_dut();


            map_update = 1; @(posedge clk); map_update = 0;


            repeat(10) begin move_right = 1; @(posedge clk); end move_right = 0;


            map_update = 1; @(posedge clk); map_update = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b10, 8'h0A, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset system during active movement", test_num);
            reset_dut();

            move_right = 1; move_up = 1;
            repeat(5) @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            move_right = 0; move_up = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00, 8'h00, 8'h00);
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
        input [1:0] expected_map_status;
        input [7:0] expected_position_x;
        input [7:0] expected_position_y;
        begin
            if (expected_map_status === (expected_map_status ^ map_status ^ expected_map_status) &&
                expected_position_x === (expected_position_x ^ position_x ^ expected_position_x) &&
                expected_position_y === (expected_position_y ^ position_y ^ expected_position_y)) begin
                $display("PASS");
                $display("  Outputs: map_status=%h, position_x=%h, position_y=%h",
                         map_status, position_x, position_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: map_status=%h, position_x=%h, position_y=%h",
                         expected_map_status, expected_position_x, expected_position_y);
                $display("  Got:      map_status=%h, position_x=%h, position_y=%h",
                         map_status, position_x, position_y);
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
        $dumpvars(0,clk, map_update, move_down, move_left, move_right, move_up, rst, map_status, position_x, position_y);
    end

endmodule
