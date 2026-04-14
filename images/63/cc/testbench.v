`timescale 1ns/1ps

module johnson_counter_10bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [9:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter_10bit dut (
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Verifying initial state after reset", test_num);
        reset_dut();

        #1;


        check_outputs(10'b0000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Verifying state after 1 clock cycle", test_num);
        reset_dut();
        @(posedge clk);
        #1;


        #1;



        check_outputs(10'b1000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Verifying state after 5 clock cycles", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #1;

        #1;


        check_outputs(10'b1111100000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Verifying state after 10 clock cycles (All 1s)", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(10'b1111111111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Verifying state after 11 clock cycles (First 0 enters)", test_num);
        reset_dut();
        repeat(11) @(posedge clk);
        #1;

        #1;


        check_outputs(10'b0111111111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Verifying state after 15 clock cycles", test_num);
        reset_dut();
        repeat(15) @(posedge clk);
        #1;

        #1;


        check_outputs(10'b0000011111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Verifying full rotation (20 clock cycles)", test_num);
        reset_dut();
        repeat(20) @(posedge clk);
        #1;

        #1;


        check_outputs(10'b0000000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Verifying wrap-around (22 clock cycles)", test_num);
        reset_dut();
        repeat(22) @(posedge clk);
        #1;

        #1;


        check_outputs(10'b1100000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter_10bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [9:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, reset, out);
    end

endmodule
