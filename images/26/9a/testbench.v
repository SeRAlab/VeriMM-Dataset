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
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros", test_num);
        h_prev = 4'd0;
        x = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple addition without overflow", test_num);
        h_prev = 4'd3;
        x = 4'd4;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition resulting in max 4-bit value", test_num);
        h_prev = 4'd7;
        x = 4'd8;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow case (modulo 16) - Result 0", test_num);
        h_prev = 4'd8;
        x = 4'd8;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow case (modulo 16) - Max values", test_num);
        h_prev = 4'd15;
        x = 4'd15;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input identity check (x=0)", test_num);
        h_prev = 4'd12;
        x = 4'd0;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hidden state identity check (h_prev=0)", test_num);
        h_prev = 4'd0;
        x = 4'd9;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry wrap around", test_num);
        h_prev = 4'd10;
        x = 4'd7;
        #1;

        check_outputs(4'd1);
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
