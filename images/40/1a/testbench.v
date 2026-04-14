`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg enable;
    reg reset;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adaptive_lms_filter dut (
        .clk(clk),
        .d(d),
        .enable(enable),
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
            enable = 0;
            x = 16'h0000;
            d = 16'h0000;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initialization Check");
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Zero Input Response");
            reset_dut();
            enable = 1;
            x = 16'h0000;
            d = 16'h0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Enable Control Verification");
            reset_dut();
            enable = 0;
            x = 16'h1000;
            d = 16'h1000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Basic Adaptation (DC Signal)");
            reset_dut();
            enable = 1;


            x = 16'h0100;
            d = 16'h0100;
            repeat(20) @(posedge clk);



            if (y > 16'h0000) begin
                $display("PASS: Filter produced positive output y=%h", y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter output y=%h stayed at 0 despite adaptation period", y);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        reg [15:0] last_y;
        begin
            test_num = 5;
            $display("Testcase 005: Tap Delay Line Operation");
            reset_dut();
            enable = 1;


            x = 16'h0200; d = 16'h0200; @(posedge clk);
            x = 16'h0400; d = 16'h0400; @(posedge clk);
            x = 16'h0600; d = 16'h0600; @(posedge clk);
            x = 16'h0800; d = 16'h0800; @(posedge clk);

            last_y = y;
            repeat(5) @(posedge clk);


            if (y != last_y) begin
                 $display("PASS: Filter output is dynamic y=%h", y);
                 pass_count = pass_count + 1;
            end else begin
                 $display("FAIL: Filter output is static y=%h", y);
                 fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Impulse Response and Settling");
            reset_dut();
            enable = 1;


            x = 16'h7FFF; d = 16'h0000; @(posedge clk);
            x = 16'h0000; d = 16'h0000;
            repeat(10) @(posedge clk);


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
        $dumpvars(0,clk, d, enable, reset, x, y);
    end

endmodule
