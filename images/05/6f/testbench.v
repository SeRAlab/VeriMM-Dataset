`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
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
        .reset(reset),
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
            reset = 1;
            x = 16'd0;
            d = 16'd0;
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
            $display("Running Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Initial Step (Weights=0)", test_num);
            reset_dut();
            x = 16'h0005;
            d = 16'h0010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0010, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Zero Input Stability", test_num);
            reset_dut();
            x = 16'h0000;
            d = 16'h00FF;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h00FF, 16'h0000);
        end
        endtask

    task testcase004;

        reg [15:0] initial_e;
        begin
            test_num = 4;
            $display("Running Testcase %03d: Basic Adaptation Direction", test_num);
            reset_dut();
            x = 16'h0001;
            d = 16'h0040;
            @(posedge clk); #1;
            initial_e = e;

            repeat(20) @(posedge clk);
            #1;



            if (e < initial_e) begin
                $display("PASS: Error decreased from %h to %h", initial_e, e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Error did not decrease. Initial: %h, Current: %h", initial_e, e);
                fail_count = fail_count + 1;
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
        $display("adaptive_lms_filter Testbench");
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
        $dumpvars(0,clk, d, reset, x, e, y);
    end

endmodule
