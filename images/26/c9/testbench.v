`timescale 1ns/1ps

module chacha20_round_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] counter;
    reg [31:0] key;
    wire [31:0] output_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_round dut (
        .counter(counter),
        .key(key),
        .output_val(output_val)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        key = 32'h00000000;
        counter = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones (Identical Inputs)", test_num);
        key = 32'hFFFFFFFF;
        counter = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complementary Bit Patterns", test_num);
        key = 32'hAAAAAAAA;
        counter = 32'h55555555;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Counter", test_num);
        key = 32'hDEADBEEF;
        counter = 32'h00000000;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit Difference", test_num);
        key = 32'h12345678;
        counter = 32'h12345679;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Random Hex Mix", test_num);
        key = 32'hCAFEBABE;
        counter = 32'hBAADF00D;
        #1;

        check_outputs(32'hCAFEBABE ^ 32'hBAADF00D);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Nibble Swap Pattern", test_num);
        key = 32'hF0F0F0F0;
        counter = 32'h0F0F0F0F;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_round Testbench");
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
        input [31:0] expected_output_val;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_val === (expected_output_val ^ output_val ^ expected_output_val)) begin
                $display("PASS");
                $display("  Outputs: output_val=%h",
                         output_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_val=%h",
                         expected_output_val);
                $display("  Got:      output_val=%h",
                         output_val);
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
