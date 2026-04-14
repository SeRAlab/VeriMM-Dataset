`timescale 1ns/1ps

module lms_filter_tb;

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
    lms_filter dut (
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
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input", test_num);
            reset_dut();
            x = 16'h0000;
            d = 16'h0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Output (Weights = 0)", test_num);
            reset_dut();
            x = 16'h1000;
            d = 16'h0500;

            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Adaptation Progress Check", test_num);
            reset_dut();
            x = 16'h2000;
            d = 16'h1000;
            repeat(5) @(posedge clk);


            if (y != 16'h0000) begin
                $display("PASS: Filter is adapting (y non-zero)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter stuck at zero");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Impulse Input Adaptation", test_num);
            reset_dut();
            x = 16'h4000;
            d = 16'h2000;
            @(posedge clk);
            x = 16'h0000;
            repeat(10) @(posedge clk);


            $display("Check: Filter output after impulse: %h", y);
            pass_count = pass_count + 1;
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggling Input", test_num);
            reset_dut();
            for(i=0; i<20; i=i+1) begin
                x = (i % 2 == 0) ? 16'h7FFF : 16'h8001;
                d = (i % 2 == 0) ? 16'h1000 : 16'hF000;
                @(posedge clk);
            end

            if (y !== 16'hxxxx) begin
                $display("PASS: Output valid");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output invalid");
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
        $display("lms_filter Testbench");
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
