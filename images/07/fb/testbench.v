`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [6:0] codeword;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data(data),
        .codeword(codeword)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Data 0000", test_num);
            data = 4'b0000;

            #1;


            check_outputs(7'b0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Data 1000", test_num);
            data = 4'b1000;

            #1;


            check_outputs(7'b1110000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Data 0100", test_num);
            data = 4'b0100;

            #1;


            check_outputs(7'b1001100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Data 0010", test_num);
            data = 4'b0010;

            #1;


            check_outputs(7'b0101010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Data 0001", test_num);
            data = 4'b0001;

            #1;


            check_outputs(7'b1101001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Data 1011", test_num);
            data = 4'b1011;

            #1;


            check_outputs(7'b0110011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Data 0111", test_num);
            data = 4'b0111;

            #1;


            check_outputs(7'b0001111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Data 1111", test_num);
            data = 4'b1111;

            #1;


            check_outputs(7'b1111111);
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
        input [6:0] expected_codeword;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codeword === (expected_codeword ^ codeword ^ expected_codeword)) begin
                $display("PASS");
                $display("  Outputs: codeword=%h",
                         codeword);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword=%h",
                         expected_codeword);
                $display("  Got:      codeword=%h",
                         codeword);
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
