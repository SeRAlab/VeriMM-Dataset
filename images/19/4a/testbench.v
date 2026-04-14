`timescale 1ns/1ps

module chacha20_simple_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] counter;
    reg [31:0] key;
    reg [31:0] nonce;
    wire [31:0] output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_simple dut (
        .counter(counter),
        .key(key),
        .nonce(nonce),
        .output_data(output_data)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            key = 32'h00000000;
            nonce = 32'h00000000;
            counter = 32'h00000000;
            #1;

            check_outputs(reference_model(key, nonce, counter));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Maximum Values", test_num);
            key = 32'hFFFFFFFF;
            nonce = 32'hFFFFFFFF;
            counter = 32'hFFFFFFFF;
            #1;

            check_outputs(reference_model(key, nonce, counter));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Walking Counter", test_num);
            key = 32'h12345678;
            nonce = 32'h0000CAFE;
            counter = 32'h00000001;
            #1;

            check_outputs(reference_model(key, nonce, counter));

            counter = 32'h00000002;
            #1;

            check_outputs(reference_model(key, nonce, counter));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Nonce Bit Sensitivity", test_num);
            key = 32'hA5A5A5A5;
            counter = 32'h00000000;
            nonce = 32'h00000001;
            #1;

            check_outputs(reference_model(key, nonce, counter));

            nonce = 32'h80000000;
            #1;

            check_outputs(reference_model(key, nonce, counter));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Mixed Bit Patterns", test_num);
            key = 32'hDEADBEEF;
            nonce = 32'h01234567;
            counter = 32'h89ABCDEF;
            #1;

            check_outputs(reference_model(key, nonce, counter));
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Key Bit Sensitivity", test_num);
            nonce = 32'h0;
            counter = 32'h0;
            key = 32'h00000001;
            #1;

            check_outputs(reference_model(key, nonce, counter));

            key = 32'h00000002;
            #1;

            check_outputs(reference_model(key, nonce, counter));
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_simple Testbench");
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
        input [31:0] expected_output_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h",
                         output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h",
                         expected_output_data);
                $display("  Got:      output_data=%h",
                         output_data);
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
