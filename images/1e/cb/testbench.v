`timescale 1ns/1ps

module checksum_generator_verifier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] checksum_in;
    reg control;
    reg [15:0] data_in;
    wire [7:0] checksum_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_generator_verifier dut (
        .checksum_in(checksum_in),
        .control(control),
        .data_in(data_in),
        .checksum_out(checksum_out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Generate checksum for all zeros", test_num);
            control = 1'b0;
            data_in = 16'h0000;
            checksum_in = 8'h00;


            #1;



            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Generate checksum for all ones", test_num);
            control = 1'b0;
            data_in = 16'hFFFF;
            checksum_in = 8'h00;


            #1;



            check_outputs(8'd16, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Generate checksum for alternating bits (0x5555)", test_num);
            control = 1'b0;
            data_in = 16'h5555;
            checksum_in = 8'h00;

            #1;


            check_outputs(8'd8, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify successful checksum (0 bits)", test_num);
            control = 1'b1;
            data_in = 16'h0000;
            checksum_in = 8'd0;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify successful checksum (16 bits)", test_num);
            control = 1'b1;
            data_in = 16'hFFFF;
            checksum_in = 8'd16;
            #1;

            check_outputs(8'd16, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify successful checksum (mixed bits 0x1234)", test_num);
            control = 1'b1;
            data_in = 16'h1234;
            checksum_in = 8'd5;
            #1;

            check_outputs(8'd5, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify failed checksum (mismatch)", test_num);
            control = 1'b1;
            data_in = 16'hF00F;
            checksum_in = 8'd7;
            #1;

            check_outputs(8'd8, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify failed checksum (all ones data, zero in)", test_num);
            control = 1'b1;
            data_in = 16'hFFFF;
            checksum_in = 8'd0;
            #1;

            check_outputs(8'd16, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_generator_verifier Testbench");
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
        input [7:0] expected_checksum_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, valid=%b",
                         checksum_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, valid=%b",
                         expected_checksum_out, expected_valid);
                $display("  Got:      checksum_out=%h, valid=%b",
                         checksum_out, valid);
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
