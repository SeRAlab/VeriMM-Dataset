`timescale 1ns/1ps

module fibonacci_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [7:0] fib1;
    wire [7:0] fib2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fibonacci_generator dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .fib1(fib1),
        .fib2(fib2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        en = 0;
        rst = 1;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Step Sequence", test_num);
        reset_dut();
        en = 1;
        @(posedge clk);
        #1 en = 0;

        #1;


        check_outputs(8'h01, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multi-step (5 cycles)", test_num);
        reset_dut();
        en = 1;
        repeat(5) @(posedge clk);
        #1 en = 0;






        #1;







        check_outputs(8'h05, 8'h08);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable/Disable Logic", test_num);
        reset_dut();
        en = 1;
        repeat(3) @(posedge clk);
        #1 en = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(8'h02, 8'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Long Sequence (Step 12)", test_num);
        reset_dut();
        en = 1;
        repeat(12) @(posedge clk);
        #1 en = 0;














        #1;















        check_outputs(8'h90, 8'hE9);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset during operation", test_num);
        reset_dut();
        en = 1;
        repeat(10) @(posedge clk);
        #2 rst = 1;
        @(posedge clk);
        #1 rst = 0;
        #1;

        check_outputs(8'h00, 8'h01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fibonacci_generator Testbench");
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
        input [7:0] expected_fib1;
        input [7:0] expected_fib2;
        begin
            if (expected_fib1 === (expected_fib1 ^ fib1 ^ expected_fib1) &&
                expected_fib2 === (expected_fib2 ^ fib2 ^ expected_fib2)) begin
                $display("PASS");
                $display("  Outputs: fib1=%h, fib2=%h",
                         fib1, fib2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fib1=%h, fib2=%h",
                         expected_fib1, expected_fib2);
                $display("  Got:      fib1=%h, fib2=%h",
                         fib1, fib2);
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
        $dumpvars(0,clk, en, rst, fib1, fib2);
    end

endmodule
