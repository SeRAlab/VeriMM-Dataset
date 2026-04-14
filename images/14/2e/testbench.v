`timescale 1ns/1ps

module adaptive_lms_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg reset;
    reg [15:0] x;
    wire [15:0] coef0;
    wire [15:0] coef1;
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
        .coef0(coef0),
        .coef1(coef1),
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
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            x = 16'h0000;
            d = 16'h0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            x = 16'h1000;
            d = 16'h1000;


            repeat(5) @(posedge clk);



            if (coef0 > 16'h0000 && y > 16'h0000) begin
                pass_count = pass_count + 1;
                $display("Test 003: PASS (Adaptation initiated)");
            end else begin
                fail_count = fail_count + 1;
                $display("Test 003: FAIL (No adaptation detected)");
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            x = 16'h2000;
            d = 16'h2000;
            repeat(5) @(posedge clk);



            x = 16'h0000;
            d = 16'h0000;
            @(posedge clk);


            #1;



            check_outputs(coef0, coef1, 16'h0000);
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
        input [15:0] expected_coef0;
        input [15:0] expected_coef1;
        input [15:0] expected_y;
        begin
            if (expected_coef0 === (expected_coef0 ^ coef0 ^ expected_coef0) &&
                expected_coef1 === (expected_coef1 ^ coef1 ^ expected_coef1) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: coef0=%h, coef1=%h, y=%h",
                         coef0, coef1, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: coef0=%h, coef1=%h, y=%h",
                         expected_coef0, expected_coef1, expected_y);
                $display("  Got:      coef0=%h, coef1=%h, y=%h",
                         coef0, coef1, y);
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
        $dumpvars(0,clk, d, reset, x, coef0, coef1, y);
    end

endmodule
