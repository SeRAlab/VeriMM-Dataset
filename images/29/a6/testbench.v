`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg [15:0] mu;
    reg rst;
    reg [15:0] x;
    wire [15:0] w;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .mu(mu),
        .rst(rst),
        .x(x),
        .w(w),
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
        x = 0;
        d = 0;
        mu = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Step Adaptation", test_num);
        reset_dut();
        x = 16'h0002;
        d = 16'h000A;
        mu = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0014, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Convergence Stability", test_num);
        reset_dut();
        mu = 16'h0001;
        x = 16'h0001;
        d = 16'h0005;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0005, 16'h0005);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Zero Input Response", test_num);
        reset_dut();
        mu = 16'h00FF;
        x = 16'h0000;
        d = 16'hFFFF;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Large Error Adaptation", test_num);
        reset_dut();
        mu = 16'h0001;
        x = 16'h0004;
        d = 16'h0064;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0190, 16'h0000);
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
        input [15:0] expected_w;
        input [15:0] expected_y;
        begin
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: w=%h, y=%h",
                         w, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h, y=%h",
                         expected_w, expected_y);
                $display("  Got:      w=%h, y=%h",
                         w, y);
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
        $dumpvars(0,clk, d, mu, rst, x, w, y);
    end

endmodule
