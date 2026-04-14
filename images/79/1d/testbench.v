`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] Hexs;
    reg [3:0] Les;
    reg [3:0] Point;
    reg [1:0] Scan;
    wire [3:0] AN;
    wire [3:0] Hex;
    wire LE;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Hexs(Hexs),
        .Les(Les),
        .Point(Point),
        .Scan(Scan),
        .AN(AN),
        .Hex(Hex),
        .LE(LE),
        .p(p)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Digit 0 (Scan=00)", test_num);

            Hexs = 16'h4321;
            Point = 4'b0001;
            Les = 4'b1110;
            Scan = 2'b00;


            #1;



            check_outputs(4'b1110, 4'h1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Digit 1 (Scan=01)", test_num);

            Hexs = 16'h4321;
            Point = 4'b0010;
            Les = 4'b1101;
            Scan = 2'b01;


            #1;



            check_outputs(4'b1101, 4'h2, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Digit 2 (Scan=10)", test_num);

            Hexs = 16'h4321;
            Point = 4'b0100;
            Les = 4'b1011;
            Scan = 2'b10;


            #1;



            check_outputs(4'b1011, 4'h3, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Digit 3 (Scan=11)", test_num);

            Hexs = 16'h4321;
            Point = 4'b1000;
            Les = 4'b0111;
            Scan = 2'b11;


            #1;



            check_outputs(4'b0111, 4'h4, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data Change Verification", test_num);

            Hexs = 16'hFEDC;
            Point = 4'b0000;
            Les = 4'b1111;
            Scan = 2'b10;


            #1;



            check_outputs(4'b1011, 4'hE, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Check Hex digit 0 mapping", test_num);
            Hexs = 16'hABCD;
            Scan = 2'b00;
            Point = 4'b1010;
            Les = 4'b0101;


            #1;



            check_outputs(4'b1110, 4'hD, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_AN;
        input [3:0] expected_Hex;
        input expected_LE;
        input expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AN === (expected_AN ^ AN ^ expected_AN) &&
                expected_Hex === (expected_Hex ^ Hex ^ expected_Hex) &&
                expected_LE === (expected_LE ^ LE ^ expected_LE) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: AN=%h, Hex=%h, LE=%b, p=%b",
                         AN, Hex, LE, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AN=%h, Hex=%h, LE=%b, p=%b",
                         expected_AN, expected_Hex, expected_LE, expected_p);
                $display("  Got:      AN=%h, Hex=%h, LE=%b, p=%b",
                         AN, Hex, LE, p);
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
