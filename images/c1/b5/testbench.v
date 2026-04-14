`timescale 1ns/1ps

module ag6502_decimal_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] ADD;
    reg D_IN;
    reg NEG;
    wire [4:0] CORR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ag6502_decimal dut (
        .ADD(ADD),
        .D_IN(D_IN),
        .NEG(NEG),
        .CORR(CORR)
    );
    task testcase001;

    begin
        test_num = 1;
        ADD = 5'h0B; D_IN = 1'b0; NEG = 1'b0;
        #1;

        check_outputs(5'h0B);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ADD = 5'h07; D_IN = 1'b1; NEG = 1'b0;
        #1;

        check_outputs(5'h07);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ADD = 5'h0D; D_IN = 1'b1; NEG = 1'b0;
        #1;

        check_outputs(5'h13);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ADD = 5'h11; D_IN = 1'b1; NEG = 1'b0;
        #1;

        check_outputs(5'h17);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ADD = 5'h15; D_IN = 1'b1; NEG = 1'b1;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ADD = 5'h02; D_IN = 1'b1; NEG = 1'b1;
        #1;

        check_outputs(5'h0C);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ag6502_decimal Testbench");
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
        input [4:0] expected_CORR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CORR === (expected_CORR ^ CORR ^ expected_CORR)) begin
                $display("PASS");
                $display("  Outputs: CORR=%h",
                         CORR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CORR=%h",
                         expected_CORR);
                $display("  Got:      CORR=%h",
                         CORR);
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
