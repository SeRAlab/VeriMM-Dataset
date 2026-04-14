`timescale 1ns/1ps

module encoder_8to3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_8to3 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: No inputs active");
            in = 8'b0000_0000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Highest priority input (0) active");
            in = 8'b0000_0001;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Priority input 1 active");
            in = 8'b0000_0010;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Priority input 7 active (Lowest)");
            in = 8'b1000_0000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Multiple inputs (0, 1, 2) - Input 0 should win");
            in = 8'b0000_0111;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Multiple inputs (4, 7) - Input 4 should win");
            in = 8'b1001_0000;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: All inputs active - Input 0 should win");
            in = 8'b1111_1111;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Priority input 3 active");
            in = 8'b0000_1000;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Multiple inputs (6, 7) - Input 6 should win");
            in = 8'b1100_0000;
            #1;

            check_outputs(3'b110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_8to3 Testbench");
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
        input [2:0] expected_out;
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
