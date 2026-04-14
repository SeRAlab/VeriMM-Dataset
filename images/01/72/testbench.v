`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] h_prev;
    reg [3:0] x;
    wire [3:0] h_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .h_prev(h_prev),
        .x(x),
        .h_new(h_new)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero inputs (0 + 0 = 0)", test_num);
            x = 4'd0;
            h_prev = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple addition (5 + 3 = 8)", test_num);
            x = 4'd5;
            h_prev = 4'd3;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with modulo (10 + 10 = 20 -> 4)", test_num);
            x = 4'd10;
            h_prev = 4'd10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (15 + 15 = 30 -> 14)", test_num);
            x = 4'd15;
            h_prev = 4'd15;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Exact wrap-around (8 + 8 = 16 -> 0)", test_num);
            x = 4'd8;
            h_prev = 4'd8;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input at max, hidden at 1 (15 + 1 = 16 -> 0)", test_num);
            x = 4'd15;
            h_prev = 4'd1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hidden at max, input at 1 (1 + 15 = 16 -> 0)", test_num);
            x = 4'd1;
            h_prev = 4'd15;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Result just below wrap (7 + 8 = 15)", test_num);
            x = 4'd7;
            h_prev = 4'd8;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hidden is zero (9 + 0 = 9)", test_num);
            x = 4'd9;
            h_prev = 4'd0;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input is zero (0 + 13 = 13)", test_num);
            x = 4'd0;
            h_prev = 4'd13;
            #1;

            check_outputs(4'd13);
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
        input [3:0] expected_h_new;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_h_new === (expected_h_new ^ h_new ^ expected_h_new)) begin
                $display("PASS");
                $display("  Outputs: h_new=%h",
                         h_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_new=%h",
                         expected_h_new);
                $display("  Got:      h_new=%h",
                         h_new);
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
