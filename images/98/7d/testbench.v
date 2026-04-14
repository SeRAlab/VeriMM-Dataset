`timescale 1ns/1ps

module bidirectional_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg dir;
    reg reset;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidirectional_shift_register dut (
        .clk(clk),
        .d(d),
        .dir(dir),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            dir = 0;
            d = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        reg [11:0] pattern;
        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %03d: Shift Left 12-bit pattern 0x5A5", test_num);
            reset_dut();
            pattern = 12'h5A5;
            dir = 1;
            for (i = 11; i >= 0; i = i - 1) begin
                d = pattern[i];
                @(negedge clk);
            end
            #1;

            check_outputs(12'h5A5);
        end
        endtask

    task testcase003;

        reg [11:0] pattern;
        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %03d: Shift Right 12-bit pattern 0xA5A", test_num);
            reset_dut();
            pattern = 12'hA5A;
            dir = 0;

            for (i = 0; i <= 11; i = i + 1) begin
                d = pattern[i];
                @(negedge clk);
            end
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %03d: Full Fill Left (0xFFF)", test_num);
            reset_dut();
            dir = 1;
            d = 1;
            for (i = 0; i < 12; i = i + 1) begin
                @(negedge clk);
            end
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %03d: Full Fill Right (0xFFF)", test_num);
            reset_dut();
            dir = 0;
            d = 1;
            for (i = 0; i < 12; i = i + 1) begin
                @(negedge clk);
            end
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %03d: Mixed Direction Shift", test_num);
            reset_dut();


            dir = 1;
            d = 1;
            repeat(4) @(negedge clk);


            dir = 0;
            d = 0;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Reset during operation", test_num);
            reset_dut();
            dir = 1;
            d = 1;
            repeat(6) @(negedge clk);


            reset = 1;
            @(negedge clk);
            reset = 0;

            #1;


            check_outputs(12'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidirectional_shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, dir, reset, q);
    end

endmodule
