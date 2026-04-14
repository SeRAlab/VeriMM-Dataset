`timescale 1ns/1ps

module encoder_32_to_5_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_32_to_5 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: No bits high (Invalid State)");
            in = 32'h0000_0000;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input bit 0 high");
            in = 32'h0000_0001;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input bit 1 high");
            in = 32'h0000_0002;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input bit 4 high");
            in = 32'h0000_0010;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input bit 10 high");
            in = 32'h0000_0400;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input bit 15 high");
            in = 32'h0000_8000;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input bit 20 high");
            in = 32'h0010_0000;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input bit 27 high");
            in = 32'h0800_0000;
            #1;

            check_outputs(5'd27);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input bit 30 high");
            in = 32'h4000_0000;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input bit 31 high");
            in = 32'h8000_0000;
            #1;

            check_outputs(5'd31);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_32_to_5 Testbench");
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
        input [4:0] expected_out;
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
