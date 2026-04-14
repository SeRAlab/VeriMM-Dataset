`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [4:0] data_in;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .control(control),
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Write all 1s and verify storage");

            control = 1;
            data_in = 5'b11111;
            #10;

            control = 0;
            data_in = 5'b00000;
            #10;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Write all 0s and verify storage");

            control = 1;
            data_in = 5'b00000;
            #10;

            control = 0;
            data_in = 5'b11111;
            #10;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Write alternating pattern 10101");

            control = 1;
            data_in = 5'b10101;
            #10;

            control = 0;
            data_in = 5'b01010;
            #10;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Write alternating pattern 01010");

            control = 1;
            data_in = 5'b01010;
            #10;

            control = 0;
            data_in = 5'b11100;
            #10;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Verify data updates only when control is high");

            control = 1;
            data_in = 5'b11001;
            #10;

            control = 0;
            data_in = 5'b00110;
            #10;

            control = 1;
            data_in = 5'b00011;
            #10;

            control = 0;
            data_in = 5'b11111;
            #10;
            #1;

            check_outputs(5'b00011);
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
