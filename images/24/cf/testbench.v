`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] symbol;
    wire [2:0] huffman_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .symbol(symbol),
        .huffman_code(huffman_code)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Encoding Symbol 0 (Highest Frequency)", test_num);
            symbol = 2'b00;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Encoding Symbol 1 (Lower Frequency)", test_num);
            symbol = 2'b01;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Encoding Symbol 2 (Lowest Frequency)", test_num);
            symbol = 2'b10;

            #1;


            check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Invalid Symbol Input (2'b11)", test_num);
            symbol = 2'b11;


            #1;



            check_outputs(3'b000);
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
        input [2:0] expected_huffman_code;
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
