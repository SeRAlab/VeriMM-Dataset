`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg rst;
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
        .rst(rst),
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
        rst = 1;
        x = 0;
        d = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: Zero Input");
        reset_dut();

        x = 16'h0000;
        d = 16'h0000;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: Initial Adaptation Step");
        reset_dut();


        x = 16'h0010;
        d = 16'h0050;

        @(posedge clk);
        #1;


        #1;



        check_outputs(16'h0050, 16'h0000);
    end
        endtask

    task testcase003;

    reg [15:0] last_e;
    begin
        test_num = 3;
        $display("Running Testcase 003: Convergence Test");
        reset_dut();

        x = 16'h0001;
        d = 16'h0100;

        @(posedge clk);
        last_e = e;

        repeat(20) @(posedge clk);
        #1;



        if (e < last_e && y > 0) begin
            $display("PASS: Error decreased and filter output increased.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: Filter not adapting. y=%h, e=%h", y, e);
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Identity Tracking (d=x)");
        reset_dut();


        x = 16'h00FF;
        d = 16'h00FF;


        repeat(50) @(posedge clk);
        #1;



        if (e < 16'h0010) begin
            $display("PASS: Filter tracked input signal effectively.");
            pass_count = pass_count + 1;
        } else begin
            $display("FAIL: High error in identity tracking. y=%h, e=%h", y, e);
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
        $dumpvars(0,clk, d, rst, x, e, y);
    end

endmodule
