`timescale 1ns/1ps

module comparator_3bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_3bit dut (
        .A(A),
        .B(B),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=0 (A == B)", test_num);
        A = 3'b000; B = 3'b000;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=7, B=7 (A == B)", test_num);
        A = 3'b111; B = 3'b111;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=7, B=0 (A > B)", test_num);
        A = 3'b111; B = 3'b000;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=7 (A < B)", test_num);
        A = 3'b000; B = 3'b111;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=4, B=2 (A > B)", test_num);
        A = 3'b100; B = 3'b010;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=5 (A < B)", test_num);
        A = 3'b001; B = 3'b101;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=3, B=3 (A == B)", test_num);
        A = 3'b011; B = 3'b011;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=1, B=0 (A > B)", test_num);
        A = 3'b001; B = 3'b000;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=0, B=1 (A < B)", test_num);
        A = 3'b000; B = 3'b001;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: A=6, B=4 (A > B)", test_num);
        A = 3'b110; B = 3'b100;
        #1;

        check_outputs(2'b01);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_3bit Testbench");
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
        input [1:0] expected_result;
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
