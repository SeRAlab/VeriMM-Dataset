`timescale 1ns/1ps

module logic_circuit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg m;
    wire n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_circuit dut (
        .clk(clk),
        .m(m),
        .n(n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            m = 0;
            @(negedge clk);

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: m=0 (1 cycle)");
            reset_dut();
            m = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: m=1 (1 cycle)");
            reset_dut();
            m = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: m=1, 1 (2 cycles)");
            reset_dut();
            m = 1; @(posedge clk);
            m = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: m=0, 0 (2 cycles)");
            reset_dut();
            m = 0; @(posedge clk);
            m = 0; @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: m=0, 0, 1 (3 cycles)");
            reset_dut();
            m = 0; @(posedge clk);
            m = 0; @(posedge clk);
            m = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: m=0, 1, 1 (3 cycles)");
            reset_dut();
            m = 0; @(posedge clk);
            m = 1; @(posedge clk);
            m = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("logic_circuit Testbench");
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
        input expected_n;
        begin
            if (expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: n=%b",
                         n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%b",
                         expected_n);
                $display("  Got:      n=%b",
                         n);
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
        $dumpvars(0,clk, m, n);
    end

endmodule
