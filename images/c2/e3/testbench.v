`timescale 1ns/1ps

module byte_setter_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] byte_num;
    reg [31:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    byte_setter dut (
        .byte_num(byte_num),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Setting byte 0 of 0xAAAAAAAA");
            in = 32'hAAAAAAAA;
            byte_num = 2'd0;
            #1;

            check_outputs(32'hAAAAAA01);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Setting byte 1 of 0xBBBBBBBB");
            in = 32'hBBBBBBBB;
            byte_num = 2'd1;
            #1;

            check_outputs(32'hBBBB01BB);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Setting byte 2 of 0xCCCCCCCC");
            in = 32'hCCCCCCCC;
            byte_num = 2'd2;
            #1;

            check_outputs(32'hCC01CCCC);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Setting byte 3 of 0xDDDDDDDD");
            in = 32'hDDDDDDDD;
            byte_num = 2'd3;
            #1;

            check_outputs(32'h01DDDDDD);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Setting byte 0 of 0x00000000");
            in = 32'h00000000;
            byte_num = 2'd0;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Setting byte 3 of 0xFFFFFFFF");
            in = 32'hFFFFFFFF;
            byte_num = 2'd3;
            #1;

            check_outputs(32'h01FFFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Setting byte 2 of 0x12345678");
            in = 32'h12345678;
            byte_num = 2'd2;
            #1;

            check_outputs(32'h12015678);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Setting byte 1 of 0xDEADBEEF");
            in = 32'hDEADBEEF;
            byte_num = 2'd1;
            #1;

            check_outputs(32'hDEAD01EF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("byte_setter Testbench");
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
