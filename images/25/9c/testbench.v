`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    reg we;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Writing 5'h0A with WE=1");
            we = 1;
            data_in = 5'h0A;
            #10;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Data retention check (WE=0, data_in changes)");
            we = 0;
            data_in = 5'h1F;
            #10;

            #1;


            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Writing maximum value 5'h1F");
            we = 1;
            data_in = 5'h1F;
            #10;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Writing minimum value 5'h00");
            we = 1;
            data_in = 5'h00;
            #10;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Verify storage stability after WE goes high to low");

            we = 1;
            data_in = 5'h15;
            #5;

            we = 0;
            #5;

            data_in = 5'h00;
            #10;

            #1;


            check_outputs(5'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Writing alternating bits pattern 5'h15 (10101)");
            we = 1;
            data_in = 5'h15;
            #10;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Overwriting 5'h15 with 5'h0E");
            we = 1;
            data_in = 5'h0E;
            #10;
            #1;

            check_outputs(5'h0E);
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
        input [4:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
