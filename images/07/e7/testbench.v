`timescale 1ns/1ps

module sha256_partial_hash_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data;
    wire [7:0] hash_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_partial_hash dut (
        .data(data),
        .hash_output(hash_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'h00000000", test_num);
        data = 32'h00000000;
        #1;

        check_outputs(8'hdf);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'h00000001", test_num);
        data = 32'h00000001;
        #1;

        check_outputs(8'h4e);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'h61626364 (abcd)", test_num);
        data = 32'h61626364;
        #1;

        check_outputs(8'h88);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'hFFFFFFFF", test_num);
        data = 32'hFFFFFFFF;
        #1;

        check_outputs(8'he0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'h12345678", test_num);
        data = 32'h12345678;
        #1;

        check_outputs(8'h13);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'hDEADBEEF", test_num);
        data = 32'hDEADBEEF;
        #1;

        check_outputs(8'h7a);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'h01020304", test_num);
        data = 32'h01020304;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 32'hAAAAAAAA", test_num);
        data = 32'hAAAAAAAA;
        #1;

        check_outputs(8'h7c);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_partial_hash Testbench");
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
        input [7:0] expected_hash_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hash_output === (expected_hash_output ^ hash_output ^ expected_hash_output)) begin
                $display("PASS");
                $display("  Outputs: hash_output=%h",
                         hash_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_output=%h",
                         expected_hash_output);
                $display("  Got:      hash_output=%h",
                         hash_output);
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
