`timescale 1ns/1ps

module binary_counter_2bit_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg En;
    reg Rst;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_2bit dut (
        .Clk(Clk),
        .En(En),
        .Rst(Rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rst <= 1;
            En <= 0;
            @(posedge Clk);
            #1;
            Rst <= 0;
            $display("Task: reset_dut - Counter Reset to 0");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Increment (0 -> 1)", test_num);
            reset_dut();
            En <= 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Count to Maximum (3)", test_num);
            reset_dut();
            En <= 1;
            repeat(3) @(posedge Clk);
            #1;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrap-around logic (3 -> 0)", test_num);
            reset_dut();
            En <= 1;
            repeat(4) @(posedge Clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable functionality (Hold)", test_num);
            reset_dut();
            En <= 1;
            @(posedge Clk);
            En <= 0;
            repeat(2) @(posedge Clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset while counting", test_num);
            reset_dut();
            En <= 1;
            repeat(2) @(posedge Clk);
            Rst <= 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Priority over Enable", test_num);
            reset_dut();
            En <= 1;
            @(posedge Clk);
            En <= 1;
            Rst <= 1;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_2bit Testbench");
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
        input [1:0] expected_Q;
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
        $dumpvars(0,Clk, En, Rst, Q);
    end

endmodule
