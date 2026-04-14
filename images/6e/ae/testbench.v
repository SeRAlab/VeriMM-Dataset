`timescale 1ns/1ps

module gate_network_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg u;
    wire v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gate_network dut (
        .clk(clk),
        .u(u),
        .v(v)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin



        u = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: u=0, check state at t=15 (Exp v=0)");
        reset_dut();
        u = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: u=0, check state at t=25 (Exp v=1)");
        reset_dut();
        u = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: u=1, check state at t=35 (Exp v=0)");
        reset_dut();
        u = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: u=1, check state at t=45 (Exp v=0)");
        reset_dut();
        u = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: u=0, check state at t=55 (Exp v=0)");
        reset_dut();
        u = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: u=0, check state at t=65 (Exp v=0)");
        reset_dut();
        u = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: u=0, check state at t=75 (Exp v=1)");
        reset_dut();
        u = 0;
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
        $display("gate_network Testbench");
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
        input expected_v;
        begin
            if (expected_v === (expected_v ^ v ^ expected_v)) begin
                $display("PASS");
                $display("  Outputs: v=%b",
                         v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v=%b",
                         expected_v);
                $display("  Got:      v=%b",
                         v);
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
        $dumpvars(0,clk, u, v);
    end

endmodule
