`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg D_IN;
    reg EN;
    wire Q_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D_IN(D_IN),
        .EN(EN),
        .Q_OUT(Q_OUT)
    );
    task testcase001;

    begin

        CLK = 0;
        D_IN = 0;
        EN = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %0d: Baseline initial state check", test_num);


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin

        CLK = 0;
        D_IN = 0;
        EN = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %0d: Attempt to load D_IN=1 with EN=1", test_num);

        EN = 1;
        D_IN = 1;
        #5 CLK = 1;
        #5 CLK = 0;
        #5;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin

        CLK = 0;
        D_IN = 0;
        EN = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %0d: Verify output stability with EN=0 and D_IN toggling", test_num);

        EN = 0;
        D_IN = 1; #5;
        D_IN = 0; #5;
        D_IN = 1; #5;


        #5 CLK = 1;
        #5 CLK = 0;
        #5;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin

        CLK = 0;
        D_IN = 0;
        EN = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %0d: High activity test (random data and clocking)", test_num);

        EN = 1;
        repeat(10) begin
            D_IN = ~D_IN;
            #2 CLK = 1;
            #2 CLK = 0;
        end
        #5;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin

        CLK = 0;
        D_IN = 0;
        EN = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %0d: Static check with EN=1 and D_IN=0", test_num);

        EN = 1;
        D_IN = 0;
        #10 CLK = 1;
        #10 CLK = 0;
        #10;


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
        $display("top_module Testbench");
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
        input expected_Q_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q_OUT === (expected_Q_OUT ^ Q_OUT ^ expected_Q_OUT)) begin
                $display("PASS");
                $display("  Outputs: Q_OUT=%b",
                         Q_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q_OUT=%b",
                         expected_Q_OUT);
                $display("  Got:      Q_OUT=%b",
                         Q_OUT);
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

endmodule
