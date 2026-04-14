`timescale 1ns/1ps

module d_ff_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg clk;
    wire b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_ff dut (
        .a(a),
        .clk(clk),
        .b(b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case %0d: Input a=1", test_num);
        a = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case %0d: Input a=0", test_num);
        a = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case %0d: Stability over multiple cycles", test_num);
        a = 1;
        @(posedge clk);
        #2;
        a = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case %0d: Transition after negedge", test_num);
        @(negedge clk);
        a = 1;
        #1;



        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_ff Testbench");
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
        input expected_b;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%b",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%b",
                         expected_b);
                $display("  Got:      b=%b",
                         b);
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
        $dumpvars(0,a, clk, b);
    end

endmodule
