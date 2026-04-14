`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire [3:0] C;
    wire [3:0] g;
    wire [3:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .C(C),
        .g(g),
        .p(p)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'b0000; B = 4'b0000; Cin = 1'b0;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'b0101; B = 4'b1010; Cin = 1'b0;
            $display("Test %0d: Alternating Bits (Propagate only)", test_num);

            #1;


            check_outputs(4'h0, 4'h0, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'b0001; B = 4'b0001; Cin = 1'b0;
            $display("Test %0d: Carry Generate bit 0", test_num);



            #1;




            check_outputs(4'h1, 4'h1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'b1111; B = 4'b0000; Cin = 1'b1;
            $display("Test %0d: Carry Propagate Cin through all bits", test_num);



            #1;




            check_outputs(4'hF, 4'h0, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b1111; B = 4'b1111; Cin = 1'b1;
            $display("Test %0d: Full Generate and Propagate with Cin", test_num);


            #1;



            check_outputs(4'hF, 4'hF, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b1010; B = 4'b0110; Cin = 1'b0;
            $display("Test %0d: Mixed P and G", test_num);






            #1;







            check_outputs(4'hE, 4'h2, 4'hC);
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
        input [3:0] expected_C;
        input [3:0] expected_g;
        input [3:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: C=%h, g=%h, p=%h",
                         C, g, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, g=%h, p=%h",
                         expected_C, expected_g, expected_p);
                $display("  Got:      C=%h, g=%h, p=%h",
                         C, g, p);
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
