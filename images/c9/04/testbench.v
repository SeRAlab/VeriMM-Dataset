`timescale 1ns/1ps

module bitwise_and_tb;

    // Testbench signals (combinational circuit)
    reg [35:0] in;
    wire [35:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Input all zeros");
            in = 36'h000000000;
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input all ones");
            in = 36'hFFFFFFFFF;
            #1;

            check_outputs(36'h0000FFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input matches mask (0x0000FFFFF)");
            in = 36'h0000FFFFF;
            #1;

            check_outputs(36'h0000FFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input only high bits (outside mask)");
            in = 36'hFFFFF0000;
            #1;

            check_outputs(36'h0000F0000 & 36'h0000FFFFF);



        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Alternating bits (0xAAAAA AAAA)");
            in = 36'hAAAAAAAAA;
            #1;

            check_outputs(36'h0000AAAAA);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating bits (0x55555 5555)");
            in = 36'h555555555;
            #1;

            check_outputs(36'h000055555);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single bit at boundary (Bit 19)");
            in = 36'h000080000;
            #1;

            check_outputs(36'h000080000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Single bit outside boundary (Bit 20)");
            in = 36'h000100000;
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and Testbench");
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
        input [35:0] expected_out;
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
