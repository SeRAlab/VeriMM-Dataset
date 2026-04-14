`timescale 1ns/1ps

module t_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg toggle_enable;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    t_flip_flop dut (
        .clk(clk),
        .toggle_enable(toggle_enable),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            toggle_enable = 0;
            @(negedge clk);


            force dut.q = 0;
            @(negedge clk);
            release dut.q;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Toggle enable low - Output should hold state");
            test_num = 1;
            reset_dut();
            toggle_enable = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Toggle enable high for one cycle - Output should toggle to 1");
            test_num = 2;
            reset_dut();
            @(negedge clk);
            toggle_enable = 1;
            @(posedge clk);
            #1;
            toggle_enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Toggle enable high for two cycles - Output should toggle 0->1->0");
            test_num = 3;
            reset_dut();
            @(negedge clk);
            toggle_enable = 1;
            repeat(2) @(posedge clk);
            #1;
            toggle_enable = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Toggle then hold - Output should stay at 1");
            test_num = 4;
            reset_dut();
            @(negedge clk);
            toggle_enable = 1;
            @(posedge clk);
            #1;
            toggle_enable = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Complex sequence (Toggle, Toggle, Hold, Toggle) - Expect 1");
            test_num = 5;
            reset_dut();
            @(negedge clk);

            toggle_enable = 1; @(posedge clk); #1;

            toggle_enable = 1; @(posedge clk); #1;

            toggle_enable = 0; @(posedge clk); #1;

            toggle_enable = 1; @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("t_flip_flop Testbench");
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, toggle_enable, q);
    end

endmodule
