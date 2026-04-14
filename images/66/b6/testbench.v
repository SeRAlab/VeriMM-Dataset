`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [3:0] s1;
    wire [3:0] s2;
    wire [3:0] s3;
    wire [3:0] s4;
    wire [3:0] s5;
    wire [3:0] s6;
    wire [3:0] s7;
    wire [3:0] s8;
    wire [7:0] sFim;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .s7(s7),
        .s8(s8),
        .sFim(sFim)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple inputs, c = 0 (Control select s5, s6)", test_num);
            a = 4'hA;
            b = 4'hC;
            c = 4'h0;






            #1;







            check_outputs(4'h8, 4'hE, 4'h7, 4'h1, 4'h8, 4'hE, 4'h0, 4'h0, 8'h8E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple inputs, c = F (Control select s7, s8)", test_num);
            a = 4'hA;
            b = 4'hC;
            c = 4'hF;





            #1;






            check_outputs(4'h8, 4'hE, 4'h7, 4'h1, 4'h0, 4'h0, 4'h7, 4'h1, 8'h71);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs All Zeros", test_num);
            a = 4'h0;
            b = 4'h0;
            c = 4'h0;



            #1;




            check_outputs(4'h0, 4'h0, 4'hF, 4'hF, 4'h0, 4'h0, 4'h0, 4'h0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Control Input c=A", test_num);
            a = 4'hF;
            b = 4'hF;
            c = 4'hA;





            #1;






            check_outputs(4'hF, 4'hF, 4'h0, 4'h0, 4'h5, 4'h5, 4'h0, 4'h0, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Inputs Ones", test_num);
            a = 4'hF;
            b = 4'hF;
            c = 4'hF;




            #1;





            check_outputs(4'hF, 4'hF, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 4'h0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Logic Mapping", test_num);
            a = 4'h9;
            b = 4'h6;
            c = 4'h3;






            #1;







            check_outputs(4'h0, 4'hF, 4'hF, 4'h0, 4'h0, 4'hC, 4'h3, 4'h0, 8'h3C);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complementary Bit Test", test_num);
            a = 4'h5;
            b = 4'h3;
            c = 4'hA;





            #1;






            check_outputs(4'h1, 4'h7, 4'hE, 4'h8, 4'h1, 4'h5, 4'hA, 4'h8, 8'hBD);
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
        input [3:0] expected_s1;
        input [3:0] expected_s2;
        input [3:0] expected_s3;
        input [3:0] expected_s4;
        input [3:0] expected_s5;
        input [3:0] expected_s6;
        input [3:0] expected_s7;
        input [3:0] expected_s8;
        input [7:0] expected_sFim;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2) &&
                expected_s3 === (expected_s3 ^ s3 ^ expected_s3) &&
                expected_s4 === (expected_s4 ^ s4 ^ expected_s4) &&
                expected_s5 === (expected_s5 ^ s5 ^ expected_s5) &&
                expected_s6 === (expected_s6 ^ s6 ^ expected_s6) &&
                expected_s7 === (expected_s7 ^ s7 ^ expected_s7) &&
                expected_s8 === (expected_s8 ^ s8 ^ expected_s8) &&
                expected_sFim === (expected_sFim ^ sFim ^ expected_sFim)) begin
                $display("PASS");
                $display("  Outputs: s1=%h, s2=%h, s3=%h, s4=%h, s5=%h, s6=%h, s7=%h, s8=%h, sFim=%h",
                         s1, s2, s3, s4, s5, s6, s7, s8, sFim);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s1=%h, s2=%h, s3=%h, s4=%h, s5=%h, s6=%h, s7=%h, s8=%h, sFim=%h",
                         expected_s1, expected_s2, expected_s3, expected_s4, expected_s5, expected_s6, expected_s7, expected_s8, expected_sFim);
                $display("  Got:      s1=%h, s2=%h, s3=%h, s4=%h, s5=%h, s6=%h, s7=%h, s8=%h, sFim=%h",
                         s1, s2, s3, s4, s5, s6, s7, s8, sFim);
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
