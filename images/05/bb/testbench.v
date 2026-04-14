`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] data_in;
    wire [15:0] codeword;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data_in(data_in),
        .codeword(codeword)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data_in = 12'h000;
            $display("Test %0d: Input Data = 12'h000 (All zeros)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data_in = 12'h001;
            $display("Test %0d: Input Data = 12'h001 (D0=1)", test_num);



            #1;




            check_outputs(16'h0007);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data_in = 12'hFFF;
            $display("Test %0d: Input Data = 12'hFFF (All ones)", test_num);





            #1;






            check_outputs(16'hFF7F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data_in = 12'hA5A;
            $display("Test %0d: Input Data = 12'hA5A (Alternating 1010_0101_1010)", test_num);






            #1;







            check_outputs(16'hA55A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data_in = 12'h5A5;
            $display("Test %0d: Input Data = 12'h5A5 (Alternating 0101_1010_0101)", test_num);






            #1;







            check_outputs(16'h5A25);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data_in = 12'h800;
            $display("Test %0d: Input Data = 12'h800 (D11=1)", test_num);



            #1;




            check_outputs(16'h8080);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data_in = 12'h008;
            $display("Test %0d: Input Data = 12'h008 (D3=1)", test_num);







            #1;








            check_outputs(16'h004B);
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
        input [15:0] expected_codeword;
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
