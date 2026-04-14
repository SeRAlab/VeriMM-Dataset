`timescale 1ns/1ps

module RLE_Encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [15:0] encoded_out;
    wire [3:0] length_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Encoder dut (
        .data_in(data_in),
        .encoded_out(encoded_out),
        .length_out(length_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones (Single run of 8)", test_num);
            data_in = 8'b11111111;

            #1;


            check_outputs(16'h000F, 4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros (Single run of 8)", test_num);
            data_in = 8'b00000000;

            #1;


            check_outputs(16'h000E, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Half ones, half zeros", test_num);
            data_in = 8'b11110000;


            #1;



            check_outputs(16'h0067, 4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (Max runs)", test_num);
            data_in = 8'b10101010;



            #1;




            check_outputs(16'h0101, 4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple varying runs", test_num);
            data_in = 8'b11000111;



            #1;




            check_outputs(16'h0543, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit change at end", test_num);
            data_in = 8'b00000001;


            #1;



            check_outputs(16'h001C, 4'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Interleaved small groups", test_num);
            data_in = 8'b11100110;




            #1;





            check_outputs(16'h0325, 4'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE_Encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_encoded_out;
        input [3:0] expected_length_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_length_out === (expected_length_out ^ length_out ^ expected_length_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, length_out=%h",
                         encoded_out, length_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, length_out=%h",
                         expected_encoded_out, expected_length_out);
                $display("  Got:      encoded_out=%h, length_out=%h",
                         encoded_out, length_out);
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
