`timescale 1ns/1ps

module decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("\nRunning Testcase Group 001: Inputs 0-3");

            test_num = 1;
            in = 4'd0;
            #1;

            check_outputs(16'h0001);

            test_num = 2;
            in = 4'd1;
            #1;

            check_outputs(16'h0002);

            test_num = 3;
            in = 4'd2;
            #1;

            check_outputs(16'h0004);

            test_num = 4;
            in = 4'd3;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase Group 002: Inputs 4-7");

            test_num = 5;
            in = 4'd4;
            #1;

            check_outputs(16'h0010);

            test_num = 6;
            in = 4'd5;
            #1;

            check_outputs(16'h0020);

            test_num = 7;
            in = 4'd6;
            #1;

            check_outputs(16'h0040);

            test_num = 8;
            in = 4'd7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase Group 003: Inputs 8-11");

            test_num = 9;
            in = 4'd8;
            #1;

            check_outputs(16'h0100);

            test_num = 10;
            in = 4'd9;
            #1;

            check_outputs(16'h0200);

            test_num = 11;
            in = 4'd10;
            #1;

            check_outputs(16'h0400);

            test_num = 12;
            in = 4'd11;
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase Group 004: Inputs 12-15");

            test_num = 13;
            in = 4'd12;
            #1;

            check_outputs(16'h1000);

            test_num = 14;
            in = 4'd13;
            #1;

            check_outputs(16'h2000);

            test_num = 15;
            in = 4'd14;
            #1;

            check_outputs(16'h4000);

            test_num = 16;
            in = 4'd15;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4to16 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_out;
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
