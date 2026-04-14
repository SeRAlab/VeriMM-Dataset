`timescale 1ns/1ps

module adaptive_lms_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
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
            x = 0;
            d = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Zero Input Response");
            reset_dut();

            repeat (20) begin
                x = 16'h0000;
                d = 16'h0000;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Unity Convergence (d = x)");
            reset_dut();



            repeat (200) begin
                x = 16'h1000;
                d = 16'h1000;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h1000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Scaled Convergence (d = 0.5x)");
            reset_dut();

            repeat (300) begin
                x = 16'h2000;
                d = 16'h1000;
                @(posedge clk);
            end


            #1;



            check_outputs(16'h1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Negative Correlation (d = -x)");
            reset_dut();

            repeat (300) begin
                x = 16'h00A0;
                d = 16'hFF60;
                @(posedge clk);
            end

            #1;


            check_outputs(16'hFF60);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Step Change Adaptation");
            reset_dut();


            repeat (150) begin
                x = 16'h1000;
                d = 16'h1000;
                @(posedge clk);
            end


            repeat (300) begin
                x = 16'h1000;
                d = 16'h0800;
                @(posedge clk);
            end

            #1;


            check_outputs(16'h0800);
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
        input [15:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, d, reset, x, y);
    end

endmodule
