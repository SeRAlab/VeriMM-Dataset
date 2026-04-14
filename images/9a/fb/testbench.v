`timescale 1ns/1ps

module decoder_5to32_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [4:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_5to32 dut (
        .enable(enable),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        $display("Test Case 001: Enable = 0, Input = 5'd10");
        enable = 0;
        in = 5'd10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Enable = 1, Input = 5'd0");
        enable = 1;
        in = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Enable = 1, Input = 5'd31");
        enable = 1;
        in = 5'd31;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Enable = 1, Input = 5'd16");
        enable = 1;
        in = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Toggle Enable (Enable 1 -> 0)");
        enable = 1;
        in = 5'd5;
        #5;
        enable = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

        integer i;
    begin
        $display("Test Case 006: Exhaustive Sweep (0 to 31)");
        enable = 1;
        for (i = 0; i < 32; i = i + 1) begin
            in = i;
            #1;

            check_outputs(32'h1 << i);
        end
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Enable = 0, Input = 5'd31");
        enable = 0;
        in = 5'd31;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_5to32 Testbench");
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
