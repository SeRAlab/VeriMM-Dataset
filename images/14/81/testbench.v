`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RW;
    reg WL;
    wire BL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .RW(RW),
        .WL(WL),
        .BL(BL)
    );

    // Clock generation (10ns period)
    initial begin
        WL = 0;
        forever #5 WL = ~WL;
    end

        task reset_dut;

    begin

        @(negedge WL);
        RW = 1;
        D = 0;
        @(posedge WL);
        @(negedge WL);
        RW = 0;
        D = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();

        @(negedge WL);
        RW = 1; D = 1;
        @(posedge WL);
        @(negedge WL);
        RW = 0;

        @(posedge WL);
        #2;
        $display("Testcase %0d: Write 1 -> Read 1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();


        @(negedge WL);
        RW = 1; D = 1;
        @(posedge WL);
        @(negedge WL);
        D = 0;
        @(posedge WL);
        @(negedge WL);
        RW = 0;

        @(posedge WL);
        #2;
        $display("Testcase %0d: Write 0 -> Read 0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();

        @(negedge WL);
        RW = 1; D = 1;
        @(posedge WL);
        @(negedge WL);
        RW = 0; D = 0;

        repeat (3) @(posedge WL);

        #2;
        $display("Testcase %0d: Data Retention Test (Hold 1)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();

        @(negedge WL);
        RW = 1; D = 1;
        @(posedge WL);
        @(negedge WL);
        RW = 0;

        @(posedge WL);
        D = 0;
        #2;
        $display("Testcase %0d: RW Isolation (D change during Read)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();

        @(negedge WL);
        RW = 1; D = 1;
        #2;
        RW = 0;

        @(posedge WL);
        #2;
        $display("Testcase %0d: WL Gating Test (Write attempt while WL low)", test_num);
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
        $display("dram_cell Testbench");
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
        input expected_BL;
        begin
            if (expected_BL === (expected_BL ^ BL ^ expected_BL)) begin
                $display("PASS");
                $display("  Outputs: BL=%b",
                         BL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BL=%b",
                         expected_BL);
                $display("  Got:      BL=%b",
                         BL);
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
        $dumpvars(0,D, RW, WL, BL);
    end

endmodule
