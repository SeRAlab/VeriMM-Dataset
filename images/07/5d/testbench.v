`timescale 1ns/1ps

module adaptive_lms_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] error;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .x(x),
        .error(error),
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
        x = 16'h0000;
        d = 16'h0000;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Input Steady State", test_num);
        reset_dut();
        x = 16'h0000;
        d = 16'h0000;
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk);
        end
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: DC Signal Convergence (x=100, d=100)", test_num);
        reset_dut();

        for (i = 0; i < 100; i = i + 1) begin
            x = 16'd100;
            d = 16'd100;
            @(posedge clk);
        end





        if (y > 16'd0 && error < 16'd100) begin
            pass_count = pass_count + 1;
            $display("PASS: Filter showed adaptation. y=%d, error=%d", y, error);
        end else begin
            fail_count = fail_count + 1;
            $display("FAIL: Filter failed to adapt. y=%d, error=%d", y, error);
        end
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pulse Response", test_num);
        reset_dut();

        x = 16'h00FF; d = 16'h00FF;
        @(posedge clk);

        x = 16'h0000; d = 16'h0000;
        for (i = 0; i < 10; i = i + 1) @(posedge clk);


        #1;



        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adaptive_lms Testbench");
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
        input [15:0] expected_error;
        input [15:0] expected_y;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: error=%h, y=%h",
                         error, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%h, y=%h",
                         expected_error, expected_y);
                $display("  Got:      error=%h, y=%h",
                         error, y);
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
        $dumpvars(0,clk, d, reset, x, error, y);
    end

endmodule
