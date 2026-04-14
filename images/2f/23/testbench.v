`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] V_fb;
    reg [7:0] V_in;
    reg clk;
    reg enable;
    reg reset;
    wire [7:0] V_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .V_fb(V_fb),
        .V_in(V_in),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .V_out(V_out)
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
        V_fb = 0;
        V_in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Basic Increment (V_fb < V_in)", test_num);
        reset_dut();
        V_in = 8'd100;
        V_fb = 8'd50;
        enable = 1;

        repeat(20) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd20);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Basic Decrement (V_fb > V_in)", test_num);
        reset_dut();

        V_in = 8'd100;
        V_fb = 8'd50;
        enable = 1;
        repeat(20) @(posedge clk);

        V_fb = 8'd150;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Disabled Operation", test_num);
        reset_dut();
        V_in = 8'd100;
        V_fb = 8'd10;
        enable = 0;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Maximum Boundary Saturation", test_num);
        reset_dut();
        V_in = 8'd255;
        V_fb = 8'd0;
        enable = 1;

        repeat(260) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Minimum Boundary Saturation", test_num);
        reset_dut();
        V_in = 8'd10;
        V_fb = 8'd100;
        enable = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("switching_regulator Testbench");
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
        input [7:0] expected_V_out;
        begin
            if (expected_V_out === (expected_V_out ^ V_out ^ expected_V_out)) begin
                $display("PASS");
                $display("  Outputs: V_out=%h",
                         V_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V_out=%h",
                         expected_V_out);
                $display("  Got:      V_out=%h",
                         V_out);
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
        $dumpvars(0,V_fb, V_in, clk, enable, reset, V_out);
    end

endmodule
