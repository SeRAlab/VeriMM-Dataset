`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    reg RE;
    reg WE;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initializing cell to 0x00 (WE=1)");
            WE = 1;
            RE = 0;
            D = 8'h00;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Writing 0xAA (WE=1, RE=0)");
            WE = 1;
            RE = 0;
            D = 8'hAA;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Holding data 0xAA (WE=0, RE=0) while D changes");
            WE = 0;
            RE = 0;
            D = 8'hFF;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Reading data (WE=0, RE=1)");
            WE = 0;
            RE = 1;
            D = 8'h55;
            #10;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Writing 0x55 (WE=1, RE=0)");
            WE = 1;
            RE = 0;
            D = 8'h55;
            #10;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Simultaneous Write and Read (WE=1, RE=1)");
            WE = 1;
            RE = 1;
            D = 8'h33;
            #10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Verify 0x33 is stored (WE=0, RE=1)");
            WE = 0;
            RE = 1;
            D = 8'h00;
            #10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        input [7:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
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
