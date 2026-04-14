`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] interrupt_requests;
    reg reset;
    wire interrupt_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable(enable),
        .interrupt_requests(interrupt_requests),
        .reset(reset),
        .interrupt_active(interrupt_active)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        interrupt_requests = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Single interrupt request (enable=1)", test_num);
        enable = 1;
        interrupt_requests = 4'b0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: No interrupt requests (enable=1)", test_num);
        enable = 1;
        interrupt_requests = 4'b0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Interrupt requests present (enable=0)", test_num);
        enable = 0;
        interrupt_requests = 4'b1111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple interrupt requests (enable=1)", test_num);
        enable = 1;
        interrupt_requests = 4'b1010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Assert reset while interrupt is active", test_num);
        enable = 1;
        interrupt_requests = 4'b0100;
        @(posedge clk);
        #1;
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Test MSB of interrupt vector (enable=1)", test_num);
        enable = 1;
        interrupt_requests = 4'b1000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Enable transition (0->1) with active requests", test_num);
        interrupt_requests = 4'b0011;
        enable = 0;
        @(posedge clk);
        #1;
        enable = 1;
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
        $display("interrupt_controller Testbench");
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
        input expected_interrupt_active;
        begin
            if (expected_interrupt_active === (expected_interrupt_active ^ interrupt_active ^ expected_interrupt_active)) begin
                $display("PASS");
                $display("  Outputs: interrupt_active=%b",
                         interrupt_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt_active=%b",
                         expected_interrupt_active);
                $display("  Got:      interrupt_active=%b",
                         interrupt_active);
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
        $dumpvars(0,clk, enable, interrupt_requests, reset, interrupt_active);
    end

endmodule
