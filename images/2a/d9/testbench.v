`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg en;
    reg we;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .d(d),
        .en(en),
        .we(we),
        .q(q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 1 and verify output", test_num);

            en = 0; we = 0; d = 0; #10;

            en = 1; we = 1; d = 1; #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read back stored 1 (Hold)", test_num);

            en = 1; we = 1; d = 1; #10;

            we = 0; d = 0; #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 0 and verify output", test_num);

            en = 0; we = 0; d = 1; #10;

            en = 1; we = 1; d = 0; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read back stored 0 (Hold)", test_num);

            en = 1; we = 1; d = 0; #10;

            we = 0; d = 1; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify High-Z when en=0", test_num);

            en = 1; we = 1; d = 1; #10;

            en = 0; we = 0; d = 1; #10;
            #1;

            check_outputs(1'bz);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Write is inhibited when en=0", test_num);

            en = 1; we = 1; d = 1; #10;

            en = 0; we = 1; d = 0; #10;

            en = 1; we = 0; #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Write is inhibited when we=0", test_num);

            en = 1; we = 1; d = 0; #10;

            en = 1; we = 0; d = 1; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify High-Z even if we=1 (en has priority)", test_num);
            en = 1; we = 1; d = 1; #10;

            en = 0; we = 1; d = 0; #10;
            #1;

            check_outputs(1'bz);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        input expected_q;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
