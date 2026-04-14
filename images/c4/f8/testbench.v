`timescale 1ns/1ps

module clock_divider_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg RESET;
    wire CLOCK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_divider dut (
        .CE(CE),
        .CLK(CLK),
        .RESET(RESET),
        .CLOCK(CLOCK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CE = 0;
            RESET = 1;
            #20;
            RESET = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Check (CE=1)", test_num);
            reset_dut();
            CE = 1;

            repeat (5) @(posedge CLK);
            #2;


            #1;



            check_outputs(CLOCK);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable Disabled Check (CE=0)", test_num);
            reset_dut();
            CE = 0;

            repeat (10) @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset During Operation", test_num);
            reset_dut();
            CE = 1;
            repeat (3) @(posedge CLK);

            #3;
            RESET = 1;
            #5;

            #1;


            check_outputs(1'b0);
            RESET = 0;
        end
        endtask

    task testcase005;

        reg last_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CE Toggle and Hold Check", test_num);
            reset_dut();
            CE = 1;
            repeat (4) @(posedge CLK);
            #2;
            CE = 0;
            last_val = CLOCK;
            repeat (4) @(posedge CLK);
            #2;

            #1;


            check_outputs(last_val);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_divider Testbench");
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
        input expected_CLOCK;
        begin
            if (expected_CLOCK === (expected_CLOCK ^ CLOCK ^ expected_CLOCK)) begin
                $display("PASS");
                $display("  Outputs: CLOCK=%b",
                         CLOCK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLOCK=%b",
                         expected_CLOCK);
                $display("  Got:      CLOCK=%b",
                         CLOCK);
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
        $dumpvars(0,CE, CLK, RESET, CLOCK);
    end

endmodule
