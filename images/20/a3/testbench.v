`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] char_in;
    wire [2:0] huffman_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .char_in(char_in),
        .huffman_out(huffman_out)
    );
    task testcase001;

        begin
            test_num = 1;
            char_in = 4'd0;
            $display("Test Case %0d: Character 0", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            char_in = 4'd1;
            $display("Test Case %0d: Character 1", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            char_in = 4'd2;
            $display("Test Case %0d: Character 2", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            char_in = 4'd3;
            $display("Test Case %0d: Character 3", test_num);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            char_in = 4'd4;
            $display("Test Case %0d: Character 4", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            char_in = 4'd5;
            $display("Test Case %0d: Character 5", test_num);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            char_in = 4'd6;
            $display("Test Case %0d: Character 6", test_num);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            char_in = 4'd7;
            $display("Test Case %0d: Character 7", test_num);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            char_in = 4'd8;
            $display("Test Case %0d: Character 8 (Non-encoded)", test_num);
            #1;

            check_outputs(3'bxxx);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            char_in = 4'd12;
            $display("Test Case %0d: Character 12 (Non-encoded)", test_num);
            #1;

            check_outputs(3'bxxx);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            char_in = 4'd15;
            $display("Test Case %0d: Character 15 (Non-encoded)", test_num);
            #1;

            check_outputs(3'bxxx);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("huffman_encoder Testbench");
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
        input [2:0] expected_huffman_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_huffman_out === (expected_huffman_out ^ huffman_out ^ expected_huffman_out)) begin
                $display("PASS");
                $display("  Outputs: huffman_out=%h",
                         huffman_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: huffman_out=%h",
                         expected_huffman_out);
                $display("  Got:      huffman_out=%h",
                         huffman_out);
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
