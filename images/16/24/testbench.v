`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] char_input;
    wire [4:0] huffman_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .char_input(char_input),
        .huffman_output(huffman_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Character 'A' (000)", test_num);
            char_input = 3'b000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Character 'B' (001)", test_num);
            char_input = 3'b001;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Character 'C' (010)", test_num);
            char_input = 3'b010;
            #1;

            check_outputs(5'b00110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Character 'D' (011)", test_num);
            char_input = 3'b011;
            #1;

            check_outputs(5'b01110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Character 'E' (100)", test_num);
            char_input = 3'b100;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing Character 'H' (111)", test_num);
            char_input = 3'b111;
            #1;

            check_outputs(5'b11111);
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
        input [4:0] expected_huffman_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_huffman_output === (expected_huffman_output ^ huffman_output ^ expected_huffman_output)) begin
                $display("PASS");
                $display("  Outputs: huffman_output=%h",
                         huffman_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: huffman_output=%h",
                         expected_huffman_output);
                $display("  Got:      huffman_output=%h",
                         huffman_output);
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
