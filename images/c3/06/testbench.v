`timescale 1ns/1ps

module clock_gate_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg EN;
    reg TE;
    wire ENCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gate dut (
        .CLK(CLK),
        .EN(EN),
        .TE(TE),
        .ENCLK(ENCLK)
    );
    task reset_inputs;

    begin
        CLK = 0;
        EN = 0;
        TE = 0;
        #10;
    end
        endtask

    task testcase001;

    begin
        reset_inputs();
        test_num = 1;
        EN = 1;
        #10;
        CLK = 1;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        reset_inputs();
        test_num = 2;
        EN = 0;
        TE = 0;
        #10;
        CLK = 1;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        reset_inputs();
        test_num = 3;
        TE = 1;
        #10;
        CLK = 1;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        reset_inputs();
        test_num = 4;
        EN = 1;
        #10;
        CLK = 1;
        #5;
        EN = 0;
        #5;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        reset_inputs();
        test_num = 5;
        CLK = 1;
        #5;
        EN = 1;
        #5;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        reset_inputs();
        test_num = 6;
        TE = 1;
        #10;
        CLK = 1;
        #5;
        TE = 0;
        #5;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        reset_inputs();
        test_num = 7;
        TE = 1;
        #10;
        CLK = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        reset_inputs();
        test_num = 8;
        EN = 1;
        TE = 1;
        #10;
        CLK = 1;
        #10;
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
        $display("clock_gate Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_ENCLK;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK)) begin
                $display("PASS");
                $display("  Outputs: ENCLK=%b",
                         ENCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ENCLK=%b",
                         expected_ENCLK);
                $display("  Got:      ENCLK=%b",
                         ENCLK);
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
