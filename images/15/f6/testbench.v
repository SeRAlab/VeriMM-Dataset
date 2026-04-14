`timescale 1ns/1ps

module bluetooth_inverter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_inverter dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros input");
            data_in = 5'b00000;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All ones input");
            data_in = 5'b11111;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternating bits (10101)");
            data_in = 5'b10101;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating bits (01010)");
            data_in = 5'b01010;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Single bit high (LSB)");
            data_in = 5'b00001;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Single bit high (MSB)");
            data_in = 5'b10000;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Random bit pattern (01101)");
            data_in = 5'b01101;
            #1;

            check_outputs(5'b10010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_inverter Testbench");
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
