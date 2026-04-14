`timescale 1ns/1ps

module pose_estimation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dx;
    reg [7:0] dy;
    reg move_cmd;
    reg rst;
    wire [31:0] movement_count;
    wire [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pose_estimation dut (
        .clk(clk),
        .dx(dx),
        .dy(dy),
        .move_cmd(move_cmd),
        .rst(rst),
        .movement_count(movement_count),
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
            dx = 0;
            dy = 0;
            move_cmd = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Single Movement", test_num);
            reset_dut();

            @(posedge clk);
            dx = 8'd10;
            dy = 8'd20;
            move_cmd = 1;
            @(posedge clk);
            move_cmd = 0;


            @(posedge clk);
            #1;

            check_outputs(32'd1, 16'd10, 16'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Movements Accumulation", test_num);
            reset_dut();


            @(posedge clk);
            dx = 8'd5; dy = 8'd5; move_cmd = 1;
            @(posedge clk);


            dx = 8'd15; dy = 8'd25; move_cmd = 1;
            @(posedge clk);


            dx = 8'd100; dy = 8'd100; move_cmd = 1;
            @(posedge clk);

            move_cmd = 0;
            @(posedge clk);


            #1;



            check_outputs(32'd3, 16'd120, 16'd130);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data applied without move_cmd", test_num);
            reset_dut();

            @(posedge clk);
            dx = 8'd50;
            dy = 8'd50;
            move_cmd = 0;
            repeat(3) @(posedge clk);


            #1;



            check_outputs(32'd0, 16'd0, 16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum 8-bit input values", test_num);
            reset_dut();

            @(posedge clk);
            dx = 8'hFF;
            dy = 8'hFF;
            move_cmd = 1;
            @(posedge clk);
            move_cmd = 0;
            @(posedge clk);

            #1;


            check_outputs(32'd1, 16'd255, 16'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero distance movement", test_num);
            reset_dut();

            @(posedge clk);
            dx = 8'd0;
            dy = 8'd0;
            move_cmd = 1;
            @(posedge clk);
            move_cmd = 0;
            @(posedge clk);


            #1;



            check_outputs(32'd1, 16'd0, 16'd0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High frequency (back-to-back) movements", test_num);
            reset_dut();

            for(i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                dx = 8'd1;
                dy = 8'd2;
                move_cmd = 1;
            end
            @(posedge clk);
            move_cmd = 0;
            @(posedge clk);

            #1;


            check_outputs(32'd10, 16'd10, 16'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pose_estimation Testbench");
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
        input [31:0] expected_movement_count;
        input [15:0] expected_x;
        input [15:0] expected_y;
        begin
            if (expected_movement_count === (expected_movement_count ^ movement_count ^ expected_movement_count) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: movement_count=%h, x=%h, y=%h",
                         movement_count, x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: movement_count=%h, x=%h, y=%h",
                         expected_movement_count, expected_x, expected_y);
                $display("  Got:      movement_count=%h, x=%h, y=%h",
                         movement_count, x, y);
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
        $dumpvars(0,clk, dx, dy, move_cmd, rst, movement_count, x, y);
    end

endmodule
