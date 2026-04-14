`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] h_prev;
    reg [3:0] x;
    wire [3:0] h_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .h_prev(h_prev),
        .x(x),
        .h_out(h_out)
    );
    task testcase001;

    begin
        $display("Testcase 001: All Zeros");
        test_num = 1;
        x = 4'b0000;
        h_prev = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Identity - Input only");
        test_num = 2;
        x = 4'b1010;
        h_prev = 4'b0000;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Identity - Hidden state only");
        test_num = 3;
        x = 4'b0000;
        h_prev = 4'b0101;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Bitwise Complement");
        test_num = 4;
        x = 4'b1111;
        h_prev = 4'b1010;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Same inputs resulting in zero");
        test_num = 5;
        x = 4'b1100;
        h_prev = 4'b1100;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Random Pattern");
        test_num = 6;
        x = 4'b0110;
        h_prev = 4'b0011;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Sequential simulation (2 steps)");
        test_num = 7;

        x = 4'h1; h_prev = 4'h0;
        #5;

        h_prev = h_out;
        x = 4'h2;

        #1;


        check_outputs(4'h3);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Sequential simulation (3 steps)");
        test_num = 8;

        x = 4'hF; h_prev = 4'h0;
        #5;

        h_prev = h_out; x = 4'hA;
        #5;

        h_prev = h_out; x = 4'h5;
        #1;

        check_outputs(4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [3:0] expected_h_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h_out === (expected_h_out ^ h_out ^ expected_h_out)) begin
                $display("PASS");
                $display("  Outputs: h_out=%h",
                         h_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_out=%h",
                         expected_h_out);
                $display("  Got:      h_out=%h",
                         h_out);
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
