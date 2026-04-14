`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [3:0] interrupt_enable;
    reg [3:0] interrupt_request;
    reg reset;
    wire [1:0] current_interrupt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clear(clear),
        .clk(clk),
        .interrupt_enable(interrupt_enable),
        .interrupt_request(interrupt_request),
        .reset(reset),
        .current_interrupt(current_interrupt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear = 0;
            interrupt_enable = 4'b0000;
            interrupt_request = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            interrupt_enable = 4'b1111;
            interrupt_request = 4'b0001;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            interrupt_enable = 4'b1111;
            interrupt_request = 4'b0100;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            interrupt_enable = 4'b1111;
            interrupt_request = 4'b1111;

            @(posedge clk);

            clear = 1;
            @(posedge clk);
            clear = 0;
            interrupt_request = 4'b1110;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            interrupt_request = 4'b1111;
            interrupt_enable = 4'b1010;

            #1;


            check_outputs(2'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            interrupt_enable = 4'b1111;
            interrupt_request = 4'b1000;
            @(posedge clk);

            clear = 1;
            @(posedge clk);
            clear = 0;
            interrupt_request = 4'b0001;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            interrupt_enable = 4'b1111;
            interrupt_request = 4'b0110;
            @(posedge clk);
            clear = 1;
            @(posedge clk);
            clear = 0;
            interrupt_request = 4'b0100;
            #1;

            check_outputs(2'd2);
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
        input [1:0] expected_current_interrupt;
        begin
            if (expected_current_interrupt === (expected_current_interrupt ^ current_interrupt ^ expected_current_interrupt)) begin
                $display("PASS");
                $display("  Outputs: current_interrupt=%h",
                         current_interrupt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_interrupt=%h",
                         expected_current_interrupt);
                $display("  Got:      current_interrupt=%h",
                         current_interrupt);
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
        $dumpvars(0,clear, clk, interrupt_enable, interrupt_request, reset, current_interrupt);
    end

endmodule
