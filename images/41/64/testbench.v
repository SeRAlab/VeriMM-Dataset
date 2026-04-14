`timescale 1ns/1ps

module square_wave_gen_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire square_wave_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    square_wave_gen dut (
        .clk(clk),
        .rst_n(rst_n),
        .square_wave_out(square_wave_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        #20;
        rst_n = 1;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking reset state", test_num);
        reset_dut();


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking first toggle (0 -> 1)", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking second toggle (1 -> 0)", test_num);
        reset_dut();
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking output after 11 clock cycles (should be 1)", test_num);
        reset_dut();
        repeat(11) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking output after 20 clock cycles (should be 0)", test_num);
        reset_dut();
        repeat(20) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking asynchronous reset mid-operation", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #2;
        rst_n = 0;
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("square_wave_gen Testbench");
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
        input expected_square_wave_out;
        begin
            if (expected_square_wave_out === (expected_square_wave_out ^ square_wave_out ^ expected_square_wave_out)) begin
                $display("PASS");
                $display("  Outputs: square_wave_out=%b",
                         square_wave_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: square_wave_out=%b",
                         expected_square_wave_out);
                $display("  Got:      square_wave_out=%b",
                         square_wave_out);
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
        $dumpvars(0,clk, rst_n, square_wave_out);
    end

endmodule
