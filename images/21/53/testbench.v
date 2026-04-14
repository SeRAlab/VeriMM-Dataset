`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [19:0] codeword_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data_in(data_in),
        .codeword_out(codeword_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 16'h0000;

            #1;


            check_outputs(20'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 16'hFFFF;







            #1;








            check_outputs(20'hFFFB7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 16'hAAAA;

            #1;


            check_outputs(20'hAAADA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 16'h5555;

            #1;


            check_outputs(20'h5552D);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 16'h0001;


            #1;



            check_outputs(20'h00007);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 16'h8000;


            #1;



            check_outputs(20'h80008);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 16'h1234;

            #1;


            check_outputs(20'h123A2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 16'hBEEF;
            #1;

            check_outputs(20'hBEE97);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hamming_encoder Testbench");
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
        input [19:0] expected_codeword_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codeword_out === (expected_codeword_out ^ codeword_out ^ expected_codeword_out)) begin
                $display("PASS");
                $display("  Outputs: codeword_out=%h",
                         codeword_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword_out=%h",
                         expected_codeword_out);
                $display("  Got:      codeword_out=%h",
                         codeword_out);
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
