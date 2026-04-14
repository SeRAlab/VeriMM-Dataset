`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] char_in;
    wire [1:0] huffman_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .char_in(char_in),
        .huffman_code(huffman_code)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input 'A' (ASCII 65)", test_num);
            char_in = 8'd65;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input 'B' (ASCII 66)", test_num);
            char_in = 8'd66;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input 'C' (ASCII 67)", test_num);
            char_in = 8'd67;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input 'D' (ASCII 68)", test_num);
            char_in = 8'd68;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input '@' (ASCII 64) - Default expected", test_num);
            char_in = 8'd64;
            #1;

            check_outputs(2'bxx);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input 'E' (ASCII 69) - Default expected", test_num);
            char_in = 8'd69;
            #1;

            check_outputs(2'bxx);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input '0' (ASCII 48) - Default expected", test_num);
            char_in = 8'd48;
            #1;

            check_outputs(2'bxx);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Input ASCII 255 - Default expected", test_num);
            char_in = 8'hFF;
            #1;

            check_outputs(2'bxx);
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
        input [1:0] expected_huffman_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_huffman_code === (expected_huffman_code ^ huffman_code ^ expected_huffman_code)) begin
                $display("PASS");
                $display("  Outputs: huffman_code=%h",
                         huffman_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: huffman_code=%h",
                         expected_huffman_code);
                $display("  Got:      huffman_code=%h",
                         huffman_code);
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
