`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] max_value;
    reg reset;
    reg start;
    wire [15:0] current_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .max_value(max_value),
        .reset(reset),
        .start(start),
        .current_count(current_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            max_value = 16'hFFFF;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Increment", test_num);
            reset_dut();
            max_value = 16'd50;
            start = 1;
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Wrap Around Logic", test_num);
            reset_dut();
            max_value = 16'd5;
            start = 1;

            repeat (6) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Start Signal Control", test_num);
            reset_dut();
            max_value = 16'd100;
            start = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Mid-operation Reset", test_num);
            reset_dut();
            max_value = 16'd100;
            start = 1;
            repeat (5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Low Boundary Wrap (max=1)", test_num);
            reset_dut();
            max_value = 16'd1;
            start = 1;

            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: High Value Consistency", test_num);
            reset_dut();
            max_value = 16'h0100;
            start = 1;
            repeat (256) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer Testbench");
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
        input [15:0] expected_current_count;
        begin
            if (expected_current_count === (expected_current_count ^ current_count ^ expected_current_count)) begin
                $display("PASS");
                $display("  Outputs: current_count=%h",
                         current_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_count=%h",
                         expected_current_count);
                $display("  Got:      current_count=%h",
                         current_count);
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
        $dumpvars(0,clk, max_value, reset, start, current_count);
    end

endmodule
