`timescale 1ns/1ps

module flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg ar;
    reg clk;
    reg d;
    reg s;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flip_flop dut (
        .ar(ar),
        .clk(clk),
        .d(d),
        .s(s),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        ar = 0;
        forever #5 ar = ~ar;
    end

        task reset_dut;

        begin
            ar = 1;
            d = 0;
            s = 0;
            #15;
            ar = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase 001: Asynchronous Reset");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk);
            d = 1;
            s = 0;
            @(negedge clk);
            #2;
            $display("Testcase 002: Load D=1 on negedge");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk);
            d = 1;
            @(negedge clk);

            d = 0;
            @(negedge clk);
            #2;
            $display("Testcase 003: Load D=0 on negedge");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            d = 0;
            s = 0;
            #2;
            @(negedge clk);
            #2;
            s = 1;
            #1;
            $display("Testcase 004: Set q=1 when s=1 and clk=0");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk);
            s = 1;
            ar = 1;
            #2;
            $display("Testcase 005: Reset priority over Set");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            wait(clk == 0);
            s = 1;
            #2;
            s = 0;

            d = 0;
            @(negedge clk);
            #2;
            $display("Testcase 006: Negedge D=0 after Set signal finished");
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
        $display("flip_flop Testbench");
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
        $dumpvars(0,ar, clk, d, s, q);
    end

endmodule
