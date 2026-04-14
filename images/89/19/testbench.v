`timescale 1ns/1ps

module t_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg clear_n;
    reg clk;
    reg t;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    t_flip_flop dut (
        .clear_n(clear_n),
        .clk(clk),
        .t(t),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clear_n = 0;
        forever #5 clear_n = ~clear_n;
    end

        task reset_dut;

        begin
            clear_n = 0;
            t = 0;
            #15;
            clear_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Toggle (T=1)", test_num);
            reset_dut();
            @(negedge clk);
            t = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Double Toggle (T=1 over 2 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            t = 1;
            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Hold State (T=0)", test_num);
            reset_dut();
            @(negedge clk);
            t = 1;
            @(posedge clk);
            @(negedge clk);
            t = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Asynchronous Clear Override", test_num);
            reset_dut();
            @(negedge clk);
            t = 1;
            @(posedge clk);
            #2;
            clear_n = 0;
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Complex Sequence (T=1, T=1, T=0, T=1)", test_num);
            reset_dut();
            @(negedge clk);
            t = 1; @(posedge clk);
            t = 1; @(posedge clk);
            t = 0; @(posedge clk);
            t = 1; @(posedge clk);
            #2;
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
        $display("t_flip_flop Testbench");
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
        $dumpvars(0,clear_n, clk, t, q);
    end

endmodule
