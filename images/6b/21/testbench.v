`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg new_bit;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clear(clear),
        .clk(clk),
        .new_bit(new_bit),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clear = 1;
        new_bit = 0;
        @(posedge clk);
        #1;
        clear = 0;
    end
        endtask
    task apply_bit;

        input bit_val;
        begin
            new_bit = bit_val;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Shift 1-0-1", test_num);
        reset_dut();
        apply_bit(1);
        apply_bit(0);
        apply_bit(1);
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Fill Register 0xAA", test_num);
        reset_dut();
        apply_bit(1); apply_bit(0); apply_bit(1); apply_bit(0);
        apply_bit(1); apply_bit(0); apply_bit(1); apply_bit(0);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflow Check", test_num);
        reset_dut();

        apply_bit(1);
        apply_bit(0); apply_bit(0); apply_bit(0); apply_bit(0);
        apply_bit(0); apply_bit(0); apply_bit(0); apply_bit(0);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Synchronous Clear Priority", test_num);
        reset_dut();
        apply_bit(1);
        apply_bit(1);
        clear = 1;
        apply_bit(1);
        #1;

        check_outputs(8'h00);
        clear = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones Fill", test_num);
        reset_dut();
        repeat(8) apply_bit(1);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,clear, clk, new_bit, data);
    end

endmodule
