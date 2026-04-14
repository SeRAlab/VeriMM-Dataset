`timescale 1ns/1ps

module chacha20_update_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] key;
    reg [31:0] nonce;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_update dut (
        .key(key),
        .nonce(nonce),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            key = 32'h00000000;
            nonce = 32'h00000000;
            $display("Test %0d: Zero Inputs", test_num);
            #1;

            check_outputs(reference_model(key, nonce));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            key = 32'hFFFFFFFF;
            nonce = 32'hFFFFFFFF;
            $display("Test %0d: Maximum Values", test_num);
            #1;

            check_outputs(reference_model(key, nonce));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            key = 32'h12345678;
            nonce = 32'h00000001;
            $display("Test %0d: Key with Nonce Bit-flip", test_num);
            #1;

            check_outputs(reference_model(key, nonce));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            key = 32'hAAAAAAAA;
            nonce = 32'h55555555;
            $display("Test %0d: Checkerboard Patterns", test_num);
            #1;

            check_outputs(reference_model(key, nonce));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            key = 32'hDEADBEEF;
            nonce = 32'hCAFEBABE;
            $display("Test %0d: Hex Pattern DEADBEEF/CAFEBABE", test_num);
            #1;

            check_outputs(reference_model(key, nonce));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            key = 32'h0000FFFF;
            nonce = 32'h00000001;
            $display("Test %0d: Low word carry test", test_num);
            #1;

            check_outputs(reference_model(key, nonce));
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_update Testbench");
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
