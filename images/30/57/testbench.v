`timescale 1ns/1ps

module comparator_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire [2:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_64bit dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A = 0, B = 0 (Equal)", test_num);
        A = 64'h0;
        B = 64'h0;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A = Max, B = Max (Equal)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A = 0, B = 1 (A < B LSB)", test_num);
        A = 64'h0;
        B = 64'h1;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A = 1, B = 0 (A > B LSB)", test_num);
        A = 64'h1;
        B = 64'h0;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A = 7...F, B = 8...0 (A < B MSB)", test_num);
        A = 64'h7FFFFFFFFFFFFFFF;
        B = 64'h8000000000000000;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A = 8...0, B = 7...F (A > B MSB)", test_num);
        A = 64'h8000000000000000;
        B = 64'h7FFFFFFFFFFFFFFF;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern (A < B)", test_num);
        A = 64'hA5A5A5A5A5A5A5A5;
        B = 64'hA5A5A5A5A5A5A5A6;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern (A > B)", test_num);
        A = 64'hFEDCBA9876543210;
        B = 64'h123456789ABCDEF0;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large number equality", test_num);
        A = 64'h123456789ABCDEF0;
        B = 64'h123456789ABCDEF0;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bits (A > B)", test_num);
        A = 64'hAAAAAAAAAAAAAAAA;
        B = 64'h5555555555555555;
        #1;

        check_outputs(3'b100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_64bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
