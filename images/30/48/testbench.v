`timescale 1ns/1ps

module chacha20_core_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] counter;
    reg [31:0] key;
    reg [31:0] nonce;
    wire [31:0] keystream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_core dut (
        .counter(counter),
        .key(key),
        .nonce(nonce),
        .keystream(keystream)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            key = 32'h00000000;
            nonce = 32'h00000000;
            counter = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition", test_num);
            key = 32'h11111111;
            nonce = 32'h22222222;
            counter = 32'h33333333;
            #1;

            check_outputs(32'h66666666);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation (32-bit overflow)", test_num);
            key = 32'hFFFFFFFF;
            nonce = 32'h00000001;
            counter = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple carry propagation", test_num);
            key = 32'hFFFFFFFF;
            nonce = 32'h00000001;
            counter = 32'h00000001;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High-bit values", test_num);
            key = 32'h80000000;
            nonce = 32'h80000000;
            counter = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum overflow", test_num);
            key = 32'hFFFFFFFF;
            nonce = 32'hFFFFFFFF;
            counter = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            key = 32'hAAAAAAAA;
            nonce = 32'h55555555;
            counter = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific hex values", test_num);
            key = 32'h12345678;
            nonce = 32'hABCDEF01;
            counter = 32'h00000010;
            #1;

            check_outputs(32'hBE024589);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_core Testbench");
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
        input [31:0] expected_keystream;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_keystream === (expected_keystream ^ keystream ^ expected_keystream)) begin
                $display("PASS");
                $display("  Outputs: keystream=%h",
                         keystream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keystream=%h",
                         expected_keystream);
                $display("  Got:      keystream=%h",
                         keystream);
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
