`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] current_position;
    reg [15:0] learning_rate;
    reg rst;
    wire [15:0] updated_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .clk(clk),
        .current_position(current_position),
        .learning_rate(learning_rate),
        .rst(rst),
        .updated_position(updated_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_position = 16'h0;
            learning_rate = 16'h0;
            @(posedge clk);
            #2 rst = 0;
            $display("System Reset Asserted");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Checking Reset State", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Learning Rate (No movement)", test_num);
            reset_dut();
            current_position = 16'h00FF;
            learning_rate = 16'h0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h00FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 50%% Learning Rate (Halving)", test_num);
            reset_dut();
            current_position = 16'h0100;
            learning_rate = 16'h0080;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0080);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Small Step Update", test_num);
            reset_dut();
            current_position = 16'h0400;
            learning_rate = 16'h0001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h03FC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Full Learning Rate (Converge to zero)", test_num);
            reset_dut();
            current_position = 16'h00AA;
            learning_rate = 16'h0100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        input [15:0] expected_updated_position;
        begin
            if (expected_updated_position === (expected_updated_position ^ updated_position ^ expected_updated_position)) begin
                $display("PASS");
                $display("  Outputs: updated_position=%h",
                         updated_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: updated_position=%h",
                         expected_updated_position);
                $display("  Got:      updated_position=%h",
                         updated_position);
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
        $dumpvars(0,clk, current_position, learning_rate, rst, updated_position);
    end

endmodule
