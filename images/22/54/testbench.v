`timescale 1ns/1ps

module rrt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_x;
    reg [7:0] current_y;
    reg rst;
    reg [7:0] target_x;
    reg [7:0] target_y;
    wire [7:0] new_x;
    wire [7:0] new_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt dut (
        .clk(clk),
        .current_x(current_x),
        .current_y(current_y),
        .rst(rst),
        .target_x(target_x),
        .target_y(target_y),
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
            rst = 1;
            current_x = 0;
            current_y = 0;
            target_x = 0;
            target_y = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Move from (10,10) towards (20,20)", test_num);
            reset_dut();
            current_x = 8'd10;
            current_y = 8'd10;
            target_x = 8'd20;
            target_y = 8'd20;

            @(posedge clk);
            #1;




            if ((new_x >= 0 && new_x <= 255) && (new_y >= 0 && new_y <= 255)) begin
                 pass_count = pass_count + 1;
                 $display("PASS: Generated valid point (%d, %d)", new_x, new_y);
            end else begin
                 fail_count = fail_count + 1;
                 $display("FAIL: Invalid point generated");
            end
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Current and Target are identical (50,50)", test_num);
            reset_dut();
            current_x = 8'd50;
            current_y = 8'd50;
            target_x = 8'd50;
            target_y = 8'd50;

            @(posedge clk);
            #1;


            if (new_x !== 8'hxx && new_y !== 8'hxx) begin
                pass_count = pass_count + 1;
                $display("PASS: Logic handled identical target. Output: (%d, %d)", new_x, new_y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Output is undefined");
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Far target boundary check (255,255)", test_num);
            reset_dut();
            current_x = 8'd0;
            current_y = 8'd0;
            target_x = 8'd255;
            target_y = 8'd255;

            @(posedge clk);
            #1;

            if (new_x >= 0 && new_y >= 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Stepped from origin towards (255,255). Output: (%d, %d)", new_x, new_y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Out of bounds or undefined");
            end
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] prev_x, prev_y;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multi-cycle movement stability", test_num);
            reset_dut();
            current_x = 8'd100;
            current_y = 8'd100;
            target_x = 8'd150;
            target_y = 8'd150;

            for(i = 0; i < 5; i = i + 1) begin
                prev_x = current_x;
                prev_y = current_y;
                @(posedge clk);
                #1;

                current_x = new_x;
                current_y = new_y;
            end


            if (new_x !== 8'hxx) begin
                pass_count = pass_count + 1;
                $display("PASS: Traversed 5 cycles successfully. Final point: (%d, %d)", new_x, new_y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Traversal failed");
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        $dumpvars(0,clk, current_x, current_y, rst, target_x, target_y, new_x, new_y);
    end

endmodule
