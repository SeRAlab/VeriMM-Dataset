`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] data_in;
    reg [127:0] key;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: FIPS 197 Round 1", test_num);


            data_in = 128'h193e4296a6d2dbe6033ad7f248ad24bb;

            key     = 128'ha0fafe1788542cb123a339392a6c7605;


            #1;



            check_outputs(128'ha49c7ff2689f352b6b5be187026a5049);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: FIPS 197 Round 2", test_num);


            data_in = 128'ha49c7ff2689f352b6b5be187026a5049;

            key     = 128'hf2c295f27a96b9435935807a7359f67f;


            #1;



            check_outputs(128'haa8f5f0361dde3ef82d24ad26832469a);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Case", test_num);

            data_in = 128'h00000000000000000000000000000000;
            key     = 128'h00000000000000000000000000000000;

            #1;


            check_outputs(128'hf4f4f4f4f4f4f4f4f4f4f4f4f4f4f4f4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Case", test_num);

            data_in = 128'hffffffffffffffffffffffffffffffff;
            key     = 128'hffffffffffffffffffffffffffffffff;





            #1;






            check_outputs(128'ha1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: FIPS 197 Round 3", test_num);

            data_in = 128'haa8f5f0361dde3ef82d24ad26832469a;
            key     = 128'h7d8045aed3543902f2190998122230d3;

            #1;


            check_outputs(128'h48e31e9e250c680870b79393a30c7f33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [127:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
