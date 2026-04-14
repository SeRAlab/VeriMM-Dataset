`timescale 1ns/1ps

module fsm_module2_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg k;
    wire r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_module2 dut (
        .clk(clk),
        .k(k),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        test_num = test_num + 1;
        k = 0;

        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Testcase %0d: Check state transition k=0", test_num);
        k = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Testcase %0d: Target output r=0", test_num);
        k = 0; @(posedge clk);
        k = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Testcase %0d: Check state transition k=1", test_num);
        k = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Testcase %0d: XOR toggle check", test_num);
        k = 1; @(posedge clk);
        k = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Testcase %0d: Target r=0 alternative sequence", test_num);
        k = 1; @(posedge clk);
        k = 0; @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Testcase %0d: Toggle r from 0 back to 1", test_num);
        k = 0; @(posedge clk);
        k = 1; @(posedge clk);
        k = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Testcase %0d: Check persistence of sticky registers", test_num);
        k = 1; @(posedge clk);
        k = 0; @(posedge clk);
        k = 0; @(posedge clk);
        #1;
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
        $display("fsm_module2 Testbench");
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
        input expected_r;
        begin
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%b",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%b",
                         expected_r);
                $display("  Got:      r=%b",
                         r);
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
        $dumpvars(0,clk, k, r);
    end

endmodule
