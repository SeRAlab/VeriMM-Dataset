`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg [15:0] x;
    wire [15:0] e;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .x(x),
        .e(e),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting filter state by feeding zero inputs...");
            x = 16'd0;
            d = 16'd0;

            repeat (32) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero Input", test_num);
            reset_dut();

            x = 16'sd0;
            d = 16'sd0;

            repeat (10) @(posedge clk);


            #1;



            check_outputs(16'sd0, 16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unit Gain Convergence (DC)", test_num);
            reset_dut();

            x = 16'sd500;
            d = 16'sd500;


            repeat (200) @(posedge clk);


            #1;



            check_outputs(16'sd0, 16'sd500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fractional Gain Convergence (0.5)", test_num);
            reset_dut();

            x = 16'sd1000;
            d = 16'sd500;

            repeat (250) @(posedge clk);


            #1;



            check_outputs(16'sd0, 16'sd500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative Gain Adaptation", test_num);
            reset_dut();

            x = 16'sd400;
            d = -16'sd400;

            repeat (200) @(posedge clk);


            #1;



            check_outputs(16'sd0, -16'sd400);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input Cancellation (Zeroing)", test_num);
            reset_dut();

            x = 16'sd2000;
            d = 16'sd0;

            repeat (200) @(posedge clk);


            #1;



            check_outputs(16'sd0, 16'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Step Response Adaptation", test_num);
            reset_dut();

            x = 16'sd100;
            d = 16'sd100;
            repeat (150) @(posedge clk);

            d = 16'sd200;
            repeat (200) @(posedge clk);


            #1;



            check_outputs(16'sd0, 16'sd200);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adaptive_lms_filter Testbench");
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
        input [15:0] expected_e;
        input [15:0] expected_y;
        begin
            if (expected_e === (expected_e ^ e ^ expected_e) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: e=%h, y=%h",
                         e, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e=%h, y=%h",
                         expected_e, expected_y);
                $display("  Got:      e=%h, y=%h",
                         e, y);
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
        $dumpvars(0,clk, d, x, e, y);
    end

endmodule
