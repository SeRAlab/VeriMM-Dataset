`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c_in;
    reg [3:0] g;
    reg [3:0] p;
    wire G;
    wire P;
    wire [2:0] c;
    wire c_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_in(c_in),
        .g(g),
        .p(p),
        .G(G),
        .P(P),
        .c(c),
        .c_out(c_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            c_in = 0; g = 4'b0000; p = 4'b0000;

            #1;


            check_outputs(1'b0, 1'b0, 3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Carry-in Only (No Propagate)", test_num);
            c_in = 1; g = 4'b0000; p = 4'b0000;


            #1;



            check_outputs(1'b0, 1'b0, 3'b000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Full Propagate Path (c_in = 0)", test_num);
            c_in = 0; g = 4'b0000; p = 4'b1111;

            #1;


            check_outputs(1'b0, 1'b1, 3'b000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Full Propagate Path (c_in = 1)", test_num);
            c_in = 1; g = 4'b0000; p = 4'b1111;

            #1;


            check_outputs(1'b0, 1'b1, 3'b111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Single Generate bit 0", test_num);
            c_in = 0; g = 4'b0001; p = 4'b1110;


            #1;



            check_outputs(1'b1, 1'b0, 3'b111, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Single Generate bit 3", test_num);
            c_in = 0; g = 4'b1000; p = 4'b0111;



            #1;




            check_outputs(1'b1, 1'b0, 3'b000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed Path Logic", test_num);
            c_in = 1; g = 4'b0100; p = 4'b1011;







            #1;








            check_outputs(1'b1, 1'b0, 3'b111, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Alternating Bits", test_num);
            c_in = 0; g = 4'b1010; p = 4'b0101;







            #1;








            check_outputs(1'b1, 1'b0, 3'b110, 1'b1);
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
        input expected_G;
        input expected_P;
        input [2:0] expected_c;
        input expected_c_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G) &&
                expected_P === (expected_P ^ P ^ expected_P) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_c_out === (expected_c_out ^ c_out ^ expected_c_out)) begin
                $display("PASS");
                $display("  Outputs: G=%b, P=%b, c=%h, c_out=%b",
                         G, P, c, c_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%b, P=%b, c=%h, c_out=%b",
                         expected_G, expected_P, expected_c, expected_c_out);
                $display("  Got:      G=%b, P=%b, c=%h, c_out=%b",
                         G, P, c, c_out);
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
