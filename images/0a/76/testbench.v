`timescale 1ns/1ps

module decoder_5_to_32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_5_to_32 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Minimum Input (0)");
        in = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Maximum Input (31)");
        in = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input 1");
        in = 5'd1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input 5 (Bit 5)");
        in = 5'd5;
        #1;

        check_outputs(32'h00000020);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input 10");
        in = 5'd10;
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input 15 (Midpoint)");
        in = 5'd15;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input 16");
        in = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input 20");
        in = 5'd20;
        #1;

        check_outputs(32'h00100000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Input 25");
        in = 5'd25;
        #1;

        check_outputs(32'h02000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Input 30");
        in = 5'd30;
        #1;

        check_outputs(32'h40000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_5_to_32 Testbench");
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
        input [31:0] expected_out;
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
