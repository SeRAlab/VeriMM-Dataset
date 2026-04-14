`timescale 1ns/1ps

module counter_up_down_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DIR;
    reg RST;
    wire [7:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_up_down dut (
        .CLK(CLK),
        .DIR(DIR),
        .RST(RST),
        .COUNT(COUNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            RST = 1;
            DIR = 1;
            @(negedge CLK);
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Check", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Up Counting (10 cycles)", test_num);
            reset_dut();
            DIR = 1;
            repeat(10) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Down Counting (Underflow check)", test_num);
            reset_dut();
            DIR = 0;
            repeat(1) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Check (Up count 256 times)", test_num);
            reset_dut();
            DIR = 1;
            repeat(256) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Direction Switching (Up 15, Down 5)", test_num);
            reset_dut();
            DIR = 1;
            repeat(15) @(posedge CLK);
            DIR = 0;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-count Synchronous Reset", test_num);
            reset_dut();
            DIR = 1;
            repeat(5) @(posedge CLK);
            @(negedge CLK);
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h00);
            RST = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Extended Down Count", test_num);
            reset_dut();
            DIR = 0;
            repeat(20) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hEC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_up_down Testbench");
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
        input [7:0] expected_COUNT;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h",
                         COUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h",
                         expected_COUNT);
                $display("  Got:      COUNT=%h",
                         COUNT);
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
        $dumpvars(0,CLK, DIR, RST, COUNT);
    end

endmodule
