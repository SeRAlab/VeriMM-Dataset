`timescale 1ns/1ps

module eight_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [8:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eight_bit_adder dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd0;
        B = 8'd0;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'd10;
        B = 8'd25;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(9'd35);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'd127;
        B = 8'd128;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(9'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'd255;
        B = 8'd1;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(9'd256);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'd255;
        B = 8'd255;
        $display("Test %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(9'd510);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'h55;
        B = 8'hAA;
        $display("Test %0d: A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'hF0;
        B = 8'hF0;
        $display("Test %0d: A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(9'h1E0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'h0F;
        B = 8'h01;
        $display("Test %0d: A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(9'h010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eight_bit_adder Testbench");
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
        input [8:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
