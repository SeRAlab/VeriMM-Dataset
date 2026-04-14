`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DIR;
    reg RST;
    wire [7:0] Count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .CLK(CLK),
        .DIR(DIR),
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
            DIR = 1;
            #12;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Counting Up 10 times", test_num);
            reset_dut();
            DIR = 1;
            repeat(10) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Counting Down 5 times (Underflow check)", test_num);
            reset_dut();
            DIR = 0;
            repeat(5) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd251);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Switching direction mid-count", test_num);
            reset_dut();
            DIR = 1;
            repeat(20) @(posedge CLK);
            DIR = 0;
            repeat(5) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Overflow check (255 to 0)", test_num);
            reset_dut();
            DIR = 1;
            repeat(257) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset during active count", test_num);
            reset_dut();
            DIR = 1;
            repeat(50) @(posedge CLK);
            @(posedge CLK);
            #2 RST = 1;
            #10 RST = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [7:0] expected_Count;
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
        $dumpvars(0,CLK, DIR, RST, Count);
    end

endmodule
