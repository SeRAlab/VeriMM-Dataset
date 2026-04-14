`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (combinational circuit)
    reg DATA;
    reg WRITE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .DATA(DATA),
        .WRITE(WRITE),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Write logic '0' and verify storage");

        WRITE = 1;
        DATA = 0;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Write logic '1' and verify storage");

        WRITE = 1;
        DATA = 1;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Verify data hold (storage) when WRITE is LOW (from '0')");

        WRITE = 1;
        DATA = 0;
        #10;

        WRITE = 0;
        DATA = 1;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Verify data hold (storage) when WRITE is LOW (from '1')");

        WRITE = 1;
        DATA = 1;
        #10;

        WRITE = 0;
        DATA = 0;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Pulse WRITE high to capture data and then hold");

        DATA = 0;
        WRITE = 0;
        #5;
        DATA = 1;
        #5;

        WRITE = 1;
        #10;
        WRITE = 0;
        DATA = 0;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Verify output follows DATA when WRITE is continuously HIGH");
        WRITE = 1;
        DATA = 0;
        #5;
        DATA = 1;
        #5;
        DATA = 0;
        #5;
        DATA = 1;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Multiple toggles with WRITE LOW");

        WRITE = 1;
        DATA = 0;
        #10;
        WRITE = 0;

        DATA = 1; #5;
        DATA = 0; #5;
        DATA = 1; #5;
        DATA = 0; #5;
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
        $display("flash_memory_cell Testbench");
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
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
