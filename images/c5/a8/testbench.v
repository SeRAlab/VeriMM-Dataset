`timescale 1ns/1ps

module clock_gate_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg en;
    reg te;
    wire en_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gate dut (
        .clk(clk),
        .en(en),
        .te(te),
        .en_clk(en_clk)
    );
    task testcase001;

    begin
        test_num = 1;
        clk = 1'b0; en = 1'b0; te = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        clk = 1'b1; en = 1'b0; te = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        clk = 1'b1; en = 1'b1; te = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        clk = 1'b1; en = 1'b0; te = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        clk = 1'b1; en = 1'b1; te = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        clk = 1'b0; en = 1'b1; te = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        en = 1'b1; te = 1'b1; clk = 1'b1;
        #5;
        clk = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        clk = 1'b1; en = 1'b1; te = 1'b1;
        #5;
        en = 1'b0;
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
        input expected_en_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en_clk === (expected_en_clk ^ en_clk ^ expected_en_clk)) begin
                $display("PASS");
                $display("  Outputs: en_clk=%b",
                         en_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en_clk=%b",
                         expected_en_clk);
                $display("  Got:      en_clk=%b",
                         en_clk);
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
