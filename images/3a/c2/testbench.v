`timescale 1ns/1ps

module adaptive_lms_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg [15:0] mu;
    reg [15:0] x;
    wire [15:0] e;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms dut (
        .clk(clk),
        .d(d),
        .mu(mu),
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
            d = 0;
            mu = 0;
            x = 0;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Zero Input Stability");
            x = 16'h0000;
            d = 16'h0000;
            mu = 16'h0001;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Simple Step Convergence (x=1, d=2)");
            mu = 16'h0001;
            x = 16'h0001;
            d = 16'h0002;

            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: No Adaptation (mu=0)");
            mu = 16'h0000;
            x = 16'h0005;
            d = 16'h000A;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(16'h000A, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Signed Convergence (x=-1, d=-4)");
            mu = 16'h0001;
            x = 16'hFFFF;
            d = 16'hFFFC;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'hFFFC);
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
        $dumpvars(0,clk, d, mu, x, e, y);
    end

endmodule
