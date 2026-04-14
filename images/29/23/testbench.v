`timescale 1ns/1ps

module d_latch_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    reg EN;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_latch dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin


        D = 0;
        EN = 1;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Capture High (EN=1, D=1)", test_num);

        D = 1;
        EN = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin

        D = 1; EN = 1; @(posedge CLK); #1;

        test_num = test_num + 1;
        $display("Testcase %0d: Capture Low (EN=1, D=0)", test_num);

        D = 0;
        EN = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Hold Low (EN=0, D=1)", test_num);

        D = 1;
        EN = 0;
        @(posedge CLK);
        #1;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        D = 1; EN = 1; @(posedge CLK); #1;

        test_num = test_num + 1;
        $display("Testcase %0d: Hold High (EN=0, D=0)", test_num);

        D = 0;
        EN = 0;
        @(posedge CLK);
        #1;


        #1;



        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple cycles with EN=0", test_num);

        EN = 0;
        D = 1; @(posedge CLK); #1;
        D = 0; @(posedge CLK); #1;
        D = 1; @(posedge CLK); #1;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Re-enabling after Hold", test_num);


        D = 1; EN = 0; @(posedge CLK); #1;


        EN = 1; @(posedge CLK); #1;

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
        $display("d_latch Testbench");
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
        $dumpvars(0,CLK, D, EN, Q);
    end

endmodule
