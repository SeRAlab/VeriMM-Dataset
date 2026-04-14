`timescale 1ns/1ps

module decoder_5to32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_5to32 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        $display("Running Test Case 001: Input = 0");
        test_num = 1;
        in = 5'd0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        $display("Running Test Case 002: Input = 1");
        test_num = 2;
        in = 5'd1;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        $display("Running Test Case 003: Input = 2");
        test_num = 3;
        in = 5'd2;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase004;

    begin
        $display("Running Test Case 004: Input = 10 (0x0A)");
        test_num = 4;
        in = 5'd10;
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase005;

    begin
        $display("Running Test Case 005: Input = 15 (0x0F)");
        test_num = 5;
        in = 5'd15;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase006;

    begin
        $display("Running Test Case 006: Input = 16 (0x10)");
        test_num = 6;
        in = 5'd16;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase007;

    begin
        $display("Running Test Case 007: Input = 24 (0x18)");
        test_num = 7;
        in = 5'd24;
        #1;

        check_outputs(32'h01000000);
    end
        endtask

    task testcase008;

    begin
        $display("Running Test Case 008: Input = 31 (0x1F)");
        test_num = 8;
        in = 5'd31;
        #1;

        check_outputs(32'h80000000);
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
