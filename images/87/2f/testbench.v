`timescale 1ns/1ps

module decoder_8to256_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [255:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_8to256 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input = 0");
        in = 8'd0;
        #1;

        check_outputs(256'b1 << 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input = 1");
        in = 8'd1;
        #1;

        check_outputs(256'b1 << 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input = 15");
        in = 8'd15;
        #1;

        check_outputs(256'b1 << 15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input = 127");
        in = 8'd127;
        #1;

        check_outputs(256'b1 << 127);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input = 128");
        in = 8'd128;
        #1;

        check_outputs(256'b1 << 128);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input = 255");
        in = 8'd255;
        #1;

        check_outputs(256'b1 << 255);
    end
        endtask

    task testcase007;

    integer i;
    begin
        $display("Test Case 007: Walking Bit Test (Selection)");

        for (i = 60; i < 70; i = i + 1) begin
            test_num = 7 + (i-60);
            in = i;
            #1;

            check_outputs(256'b1 << i);
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
        $display("decoder_8to256 Testbench");
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
        input [255:0] expected_out;
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
