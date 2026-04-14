`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg request;
    wire interrupt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable(enable),
        .request(request),
        .interrupt(interrupt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        request = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Basic interrupt trigger");
        reset_dut();
        enable = 1;
        request = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Interrupt persistence");
        reset_dut();
        enable = 1;
        request = 1;
        @(posedge clk);
        #1;
        request = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Deactivation via Enable");
        reset_dut();
        enable = 1;
        request = 1;
        @(posedge clk);
        #1;
        enable = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Request ignored when disabled");
        reset_dut();
        enable = 0;
        request = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Pulse Request");
        reset_dut();
        enable = 1;
        request = 1;
        @(posedge clk);
        #1;
        request = 0;
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Testcase 006: Enable toggle clear");
        reset_dut();
        enable = 1;
        request = 1;
        @(posedge clk);
        #1;
        enable = 0;
        @(posedge clk);
        #1;
        enable = 1;
        request = 0;
        @(posedge clk);
        #2;
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
        $display("interrupt_controller Testbench");
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
        input expected_interrupt;
        begin
            if (expected_interrupt === (expected_interrupt ^ interrupt ^ expected_interrupt)) begin
                $display("PASS");
                $display("  Outputs: interrupt=%b",
                         interrupt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt=%b",
                         expected_interrupt);
                $display("  Got:      interrupt=%b",
                         interrupt);
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
        $dumpvars(0,clk, enable, request, interrupt);
    end

endmodule
