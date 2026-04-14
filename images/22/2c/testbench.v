`timescale 1ns/1ps

module rrt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire valid;
    wire [2:0] x;
    wire [2:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_controller dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .valid(valid),
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
            enable = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase001: Reset/Idle State Check");
            reset_dut();

            #1;


            check_outputs(1'b0, x, y);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase002: Single Point Generation Check");
            reset_dut();
            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs((x < 5 && y < 5), x, y);
            enable = 0;
        end
        endtask

    task testcase003;

        integer i;
        reg fault_detected;
        begin
            $display("\nRunning Testcase003: Multiple Cycle Boundary Check");
            reset_dut();
            enable = 1;
            fault_detected = 0;

            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
                #1;

                if (valid !== (x < 5 && y < 5)) begin
                    fault_detected = 1;
                end
            end



            #1;




            check_outputs((x < 5 && y < 5) && !fault_detected, x, y);
            enable = 0;
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase004: Enable Low Check");
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, x, y);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase005: Mid-operation Reset Check");
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, x, y);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_valid;
        input [2:0] expected_x;
        input [2:0] expected_y;
        begin
            if (expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: valid=%b, x=%h, y=%h",
                         valid, x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid=%b, x=%h, y=%h",
                         expected_valid, expected_x, expected_y);
                $display("  Got:      valid=%b, x=%h, y=%h",
                         valid, x, y);
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
        $dumpvars(0,clk, enable, reset, valid, x, y);
    end

endmodule
