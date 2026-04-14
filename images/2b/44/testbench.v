`timescale 1ns/1ps

module KoggeStoneAdder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire COUT;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KoggeStoneAdder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'h0 + 4'h0", test_num);
        A = 4'h0;
        B = 4'h0;
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'd7 + 4'd8", test_num);
        A = 4'd7;
        B = 4'd8;
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'hF + 4'hF", test_num);
        A = 4'hF;
        B = 4'hF;
        #1;

        check_outputs(1'b1, 4'hE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'hF + 4'h1", test_num);
        A = 4'hF;
        B = 4'h1;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'b1010 + 4'b0101", test_num);
        A = 4'b1010;
        B = 4'b0101;
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'd13 + 4'd3", test_num);
        A = 4'd13;
        B = 4'd3;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'd9 + 4'd6", test_num);
        A = 4'd9;
        B = 4'd6;
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'd11 + 4'd7", test_num);
        A = 4'd11;
        B = 4'd7;
        #1;

        check_outputs(1'b1, 4'h2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'b0001 + 4'b0001", test_num);
        A = 4'b0001;
        B = 4'b0001;
        #1;

        check_outputs(1'b0, 4'b0010);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 4'b0100 + 4'b0100", test_num);
        A = 4'b0100;
        B = 4'b0100;
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KoggeStoneAdder Testbench");
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
        input expected_COUT;
        input [3:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
