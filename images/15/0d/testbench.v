`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RW;
    reg W;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .RW(RW),
        .W(W),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        W = 0;
        forever #5 W = ~W;
    end

        task reset_dut;

    begin
        @(negedge W);
        D = 0;
        RW = 1;
        @(posedge W);
        #1;
        RW = 0;
        D = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write 1 and Read 1", test_num);
        reset_dut();


        @(negedge W);
        D = 1;
        RW = 1;
        @(posedge W);
        #1;


        RW = 0;
        @(posedge W);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write 0 and Read 0", test_num);

        @(negedge W);
        D = 1; RW = 1;
        @(posedge W);
        #1;

        reset_dut();


        RW = 0;
        @(posedge W);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Read-Only Mode Verification", test_num);
        reset_dut();


        @(negedge W);
        D = 1;
        RW = 0;
        @(posedge W);
        #1;


        @(posedge W);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Data Persistence check", test_num);
        reset_dut();


        @(negedge W);
        D = 1;
        RW = 1;
        @(posedge W);
        #1;


        RW = 0;
        D = 0;
        repeat(3) @(posedge W);
        #1;

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
        $display("dram_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,D, RW, W, Q);
    end

endmodule
