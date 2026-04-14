`timescale 1ns/1ps

module DAC_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_Controller dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Minimum value (0x0000)");
            data_in = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Maximum value (0xFFFF)");
            data_in = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternating pattern 1 (0x5555)");
            data_in = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating pattern 2 (0xAAAA)");
            data_in = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bit 0 high (0x0001)");
            data_in = 16'h0001;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bit 15 high (0x8000)");
            data_in = 16'h8000;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Common value (0x1234)");
            data_in = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Hex pattern (0xABCD)");
            data_in = 16'hABCD;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Middle value (0x7FFF)");
            data_in = 16'h7FFF;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Boundary value (0x8001)");
            data_in = 16'h8001;
            #1;

            check_outputs(16'h8001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_Controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_data_out;
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
