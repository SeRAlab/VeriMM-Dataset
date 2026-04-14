`timescale 1ns/1ps

module Gray_counter_4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Gray_counter_4 dut (
        .clk(clk),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        @(posedge clk);
        #2;
        rst_n = 1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Increment 1 step (Binary 1)", test_num);
        reset_dut();
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Increment 3 steps (Binary 3)", test_num);
        reset_dut();
        repeat(3) @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Mid-point Check (Binary 7)", test_num);
        reset_dut();
        repeat(7) @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Upper Value Check (Binary 12)", test_num);
        reset_dut();
        repeat(12) @(posedge clk);
        #1;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Maximum Value Check (Binary 15)", test_num);
        reset_dut();
        repeat(15) @(posedge clk);
        #1;

        #1;


        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Wrap-around Check (Binary 16 -> 0)", test_num);
        reset_dut();
        repeat(16) @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Gray_counter_4 Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, rst_n, Q);
    end

endmodule
