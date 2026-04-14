`timescale 1ns/1ps

module CountOnes_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CountOnes dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in = 8'b00000000;
            $display("Test %0d: All zeros (00000000)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in = 8'b11111111;
            $display("Test %0d: All ones (11111111)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in = 8'b10101010;
            $display("Test %0d: Alternating bits starting with 1 (10101010)", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in = 8'b01010101;
            $display("Test %0d: Alternating bits starting with 0 (01010101)", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in = 8'b00000001;
            $display("Test %0d: LSB only (00000001)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in = 8'b10000000;
            $display("Test %0d: MSB only (10000000)", test_num);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in = 8'b01111110;
            $display("Test %0d: Central bits (01111110)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in = 8'b11110000;
            $display("Test %0d: Upper nibble only (11110000)", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in = 8'b00001111;
            $display("Test %0d: Lower nibble only (00001111)", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in = 8'b10110111;
            $display("Test %0d: Random pattern (10110111)", test_num);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            in = 8'b11111110;
            $display("Test %0d: Seven ones (11111110)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            in = 8'b00110100;
            $display("Test %0d: Pattern with 3 ones (00110100)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CountOnes Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [3:0] expected_out;
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
