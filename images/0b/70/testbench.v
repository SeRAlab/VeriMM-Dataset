`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg up_down;
    wire [3:0] count;
    wire max_reached;
    wire min_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .up_down(up_down),
        .count(count),
        .max_reached(max_reached),
        .min_reached(min_reached)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            enable = 0;
            up_down = 0;
            @(negedge clk);
            reset = 0;
            $display("\nRunning %0d...", test_num);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enable = 1;
            up_down = 1;
            repeat(5) @(negedge clk);
            enable = 0;

            #1;


            check_outputs(4'd5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable = 0;
            up_down = 1;
            repeat(5) @(negedge clk);

            #1;


            check_outputs(4'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable = 1;
            up_down = 1;
            repeat(15) @(negedge clk);
            enable = 0;

            #1;


            check_outputs(4'd15, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enable = 1;
            up_down = 1;
            repeat(16) @(negedge clk);
            enable = 0;

            #1;


            check_outputs(4'd0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            enable = 1;
            up_down = 1;
            repeat(10) @(negedge clk);

            up_down = 0;
            repeat(4) @(negedge clk);
            enable = 0;

            #1;


            check_outputs(4'd6, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            enable = 1;
            up_down = 0;
            repeat(1) @(negedge clk);
            enable = 0;

            #1;


            check_outputs(4'd15, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            enable = 1; up_down = 1;
            repeat(3) @(negedge clk);
            enable = 0;
            repeat(3) @(negedge clk);
            enable = 1;
            repeat(2) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(4'd5, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [3:0] expected_count;
        input expected_max_reached;
        input expected_min_reached;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_reached === (expected_max_reached ^ max_reached ^ expected_max_reached) &&
                expected_min_reached === (expected_min_reached ^ min_reached ^ expected_min_reached)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_reached=%b, min_reached=%b",
                         count, max_reached, min_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_reached=%b, min_reached=%b",
                         expected_count, expected_max_reached, expected_min_reached);
                $display("  Got:      count=%h, max_reached=%b, min_reached=%b",
                         count, max_reached, min_reached);
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
        $dumpvars(0,clk, enable, reset, up_down, count, max_reached, min_reached);
    end

endmodule
