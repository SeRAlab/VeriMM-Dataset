`timescale 1ns/1ps

module JKFlipFlop_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg j;
    reg k;
    reg reset;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JKFlipFlop dut (
        .clk(clk),
        .j(j),
        .k(k),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            j = 0;
            k = 0;
            #12;
            reset = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: J=1, K=0 (Set)");
            reset_dut();
            @(negedge clk);
            j = 1; k = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: J=0, K=1 (Clear)");
            reset_dut();

            @(negedge clk);
            j = 1; k = 0;
            @(posedge clk);

            @(negedge clk);
            j = 0; k = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: J=1, K=1 (Toggle 0->1)");
            reset_dut();
            @(negedge clk);
            j = 1; k = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: J=1, K=1 (Toggle 1->0)");
            reset_dut();

            @(negedge clk);
            j = 1; k = 0;
            @(posedge clk);

            @(negedge clk);
            j = 1; k = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: J=0, K=0 (Hold 0)");
            reset_dut();
            @(negedge clk);
            j = 0; k = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: J=0, K=0 (Hold 1)");
            reset_dut();

            @(negedge clk);
            j = 1; k = 0;
            @(posedge clk);

            @(negedge clk);
            j = 0; k = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Asynchronous Reset Priority");
            reset_dut();

            @(negedge clk);
            j = 1; k = 0;
            @(posedge clk);
            #2;

            reset = 1;
            #1;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JKFlipFlop Testbench");
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
        $dumpvars(0,clk, j, k, reset, q);
    end

endmodule
