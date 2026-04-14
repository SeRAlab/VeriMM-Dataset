`timescale 1ns/1ps

module circular_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg shift;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    circular_shift_register dut (
        .clk(clk),
        .reset(reset),
        .shift(shift),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        reset <= 1;
        shift <= 0;
        @(posedge clk);
        reset <= 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift from all-zeros", test_num);
        reset_dut();
        shift <= 1;
        repeat(5) @(posedge clk);
        shift <= 0;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift right once (10000 -> 01000)", test_num);
        reset_dut();

        force dut.q = 5'b10000;
        @(posedge clk);
        release dut.q;
        shift <= 1;
        @(posedge clk);
        shift <= 0;
        #1;

        check_outputs(5'b01000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Circularity wrap-around (00001 -> 10000)", test_num);
        reset_dut();
        force dut.q = 5'b00001;
        @(posedge clk);
        release dut.q;
        shift <= 1;
        @(posedge clk);
        shift <= 0;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full rotation (shift 5 times)", test_num);
        reset_dut();
        force dut.q = 5'b10100;
        @(posedge clk);
        release dut.q;
        shift <= 1;
        repeat(5) @(posedge clk);
        shift <= 0;
        #1;

        check_outputs(5'b10100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset priority over shift", test_num);
        reset_dut();
        force dut.q = 5'b11111;
        @(posedge clk);
        release dut.q;
        reset <= 1;
        shift <= 1;
        @(posedge clk);
        reset <= 0;
        shift <= 0;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("circular_shift_register Testbench");
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
        input [4:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, reset, shift, q);
    end

endmodule
