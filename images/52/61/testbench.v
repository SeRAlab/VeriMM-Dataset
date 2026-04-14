`timescale 1ns/1ps

module subtractor_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire [1:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_2bit dut (
        .a(a),
        .b(b),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 2'b00;
        b = 2'b00;
        $display("Test %0d: a=0, b=0 (Zero Case)", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 2'b10;
        b = 2'b01;
        $display("Test %0d: a=2, b=1 (Basic Subtraction)", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 2'b11;
        b = 2'b11;
        $display("Test %0d: a=3, b=3 (Full range, zero result)", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 2'b00;
        b = 2'b01;
        $display("Test %0d: a=0, b=1 (Borrow case/Underflow)", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 2'b01;
        b = 2'b10;
        $display("Test %0d: a=1, b=2 (Borrow case)", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 2'b00;
        b = 2'b10;
        $display("Test %0d: a=0, b=2 (Underflow by 2)", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 2'b11;
        b = 2'b00;
        $display("Test %0d: a=3, b=0 (Subtracting zero)", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 2'b01;
        b = 2'b11;
        $display("Test %0d: a=1, b=3 (Underflow case)", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_2bit Testbench");
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
        input [1:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
