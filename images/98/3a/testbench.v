`timescale 1ns/1ps

module binary_decoder_6to64_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] in;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder_6to64 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Input = 0");
            in = 6'd0;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Input = 1");
            in = 6'd1;
            #1;

            check_outputs(64'h0000000000000002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Input = 15 (Mid-low range)");
            in = 6'd15;
            #1;

            check_outputs(64'h0000000000008000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Input = 31 (Boundary of lower 32 bits)");
            in = 6'd31;
            #1;

            check_outputs(64'h0000000080000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Input = 32 (Boundary of upper 32 bits)");
            in = 6'd32;
            #1;

            check_outputs(64'h0000000100000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Input = 48 (Upper range)");
            in = 6'd48;
            #1;

            check_outputs(64'h0001000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Input = 63 (Maximum value)");
            in = 6'd63;
            #1;

            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Test Case 008: Exhaustive Sweep (0 to 63)");
            for (i = 0; i < 64; i = i + 1) begin
                in = i;
                #1;

                check_outputs(64'h1 << i);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder_6to64 Testbench");
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
        input [63:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
