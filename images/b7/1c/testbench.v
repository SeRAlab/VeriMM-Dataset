`timescale 1ns/1ps

module mod10_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    wire [3:0] Count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mod10_counter dut (
        .CLK(CLK),
        .RST(RST),
        .Count(Count)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying initial reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying increment by 1...", test_num);
            reset_dut();
            @(posedge CLK);
            #2;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying count reaching 9...", test_num);
            reset_dut();
            repeat(9) @(posedge CLK);
            #2;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying rollover from 9 to 0...", test_num);
            reset_dut();
            repeat(10) @(posedge CLK);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying counter after multiple cycles (13)...", test_num);
            reset_dut();
            repeat(13) @(posedge CLK);
            #2;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying counter after 20 cycles (rollover twice)...", test_num);
            reset_dut();
            repeat(20) @(posedge CLK);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Verifying reset in middle of sequence...", test_num);
            reset_dut();
            repeat(5) @(posedge CLK);
            #1;
            RST = 1;
            #10;
            RST = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mod10_counter Testbench");
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
        input [3:0] expected_Count;
        begin
            if (expected_Count === (expected_Count ^ Count ^ expected_Count)) begin
                $display("PASS");
                $display("  Outputs: Count=%h",
                         Count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Count=%h",
                         expected_Count);
                $display("  Got:      Count=%h",
                         Count);
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
        $dumpvars(0,CLK, RST, Count);
    end

endmodule
