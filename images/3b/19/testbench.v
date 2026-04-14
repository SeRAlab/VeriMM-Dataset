`timescale 1ns/1ps

module huffman_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] frequencies;
    wire [19:0] huffman_codes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    huffman_encoder dut (
        .frequencies(frequencies),
        .huffman_codes(huffman_codes)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Ascending Frequencies (1, 2, 3, 4, 5)", test_num);
            frequencies = {4'd1, 4'd2, 4'd3, 4'd4, 4'd5};

            #1;


            check_outputs(20'h0248C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Uniform Frequencies (5, 5, 5, 5, 5)", test_num);
            frequencies = {4'd5, 4'd5, 4'd5, 4'd5, 4'd5};


            #1;



            check_outputs(20'h02468);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Skewed Frequencies (1, 2, 4, 8, 14)", test_num);
            frequencies = {4'd1, 4'd2, 4'd4, 4'd8, 4'd14};

            #1;


            check_outputs(20'h01248);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One Dominant Frequency (1, 1, 1, 1, 15)", test_num);
            frequencies = {4'd1, 4'd1, 4'd1, 4'd1, 4'd15};

            #1;


            check_outputs(20'h02468);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Frequency Groups (1, 1, 2, 8, 8)", test_num);
            frequencies = {4'd1, 4'd1, 4'd2, 4'd8, 4'd8};

            #1;


            check_outputs(20'h0248C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Frequencies (15, 15, 15, 15, 15)", test_num);
            frequencies = {4'hf, 4'hf, 4'hf, 4'hf, 4'hf};
            #1;

            check_outputs(20'h02468);
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
        input [19:0] expected_huffman_codes;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_huffman_codes === (expected_huffman_codes ^ huffman_codes ^ expected_huffman_codes)) begin
                $display("PASS");
                $display("  Outputs: huffman_codes=%h",
                         huffman_codes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: huffman_codes=%h",
                         expected_huffman_codes);
                $display("  Got:      huffman_codes=%h",
                         huffman_codes);
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
