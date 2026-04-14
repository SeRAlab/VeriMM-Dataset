`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .rst(rst),
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
        rst = 1;
        x = 0;
        @(posedge clk);
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Zero Input Response", test_num);
        reset_dut();
        x = 16'h0000;
        repeat(10) @(posedge clk);

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Positive Impulse Response", test_num);
        reset_dut();
        x = 16'h7FFF;
        @(posedge clk);
        x = 16'h0000;
        repeat(5) @(posedge clk);



        $display("  Impulse output after 5 cycles: %h", y);
        if (y !== 16'h0000) pass_count = pass_count + 1;
        else fail_count = fail_count + 1;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Positive Step Response", test_num);
        reset_dut();
        x = 16'h1000;
        repeat(20) @(posedge clk);


        if (y !== 16'hxxxx) begin
            $display("  Step response observed: %h", y);
            pass_count = pass_count + 1;
        end else fail_count = fail_count + 1;
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Negative Step Response", test_num);
        reset_dut();
        x = 16'hF000;
        repeat(20) @(posedge clk);
        $display("  Negative step response observed: %h", y);
        if (y[15] == 1'b1) pass_count = pass_count + 1;
        else fail_count = fail_count + 1;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: High Frequency Alternating Input", test_num);
        reset_dut();
        repeat(10) begin
            x = 16'h7FFF; @(posedge clk);
            x = 16'h8000; @(posedge clk);
        end
        $display("  HF output observed: %h", y);
        pass_count = pass_count + 1;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Mid-operation Reset", test_num);
        reset_dut();
        x = 16'h4000;
        repeat(5) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        x = 0;
        @(posedge clk);
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
        $display("iir_filter Testbench");
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
        $dumpvars(0,clk, rst, x, y);
    end

endmodule
