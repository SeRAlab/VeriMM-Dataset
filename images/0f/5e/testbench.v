`timescale 1ns/1ps

module turbo_encoder_tb;

    // Testbench signals (combinational circuit)
    reg data_in;
    wire encoded_out1;
    wire encoded_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    turbo_encoder dut (
        .data_in(data_in),
        .encoded_out1(encoded_out1),
        .encoded_out2(encoded_out2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Logic Low", test_num);
            data_in = 1'b0;
            #10;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Logic High", test_num);
            data_in = 1'b1;
            #10;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition Low to High", test_num);
            data_in = 1'b0;
            #5;
            data_in = 1'b1;
            #10;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition High to Low", test_num);
            data_in = 1'b1;
            #5;
            data_in = 1'b0;
            #10;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Toggle Check", test_num);
            data_in = 1'b0; #2;
            data_in = 1'b1; #2;
            data_in = 1'b0; #2;
            data_in = 1'b1; #10;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("turbo_encoder Testbench");
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
        input expected_encoded_out1;
        input expected_encoded_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_out1 === (expected_encoded_out1 ^ encoded_out1 ^ expected_encoded_out1) &&
                expected_encoded_out2 === (expected_encoded_out2 ^ encoded_out2 ^ expected_encoded_out2)) begin
                $display("PASS");
                $display("  Outputs: encoded_out1=%b, encoded_out2=%b",
                         encoded_out1, encoded_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out1=%b, encoded_out2=%b",
                         expected_encoded_out1, expected_encoded_out2);
                $display("  Got:      encoded_out1=%b, encoded_out2=%b",
                         encoded_out1, encoded_out2);
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
