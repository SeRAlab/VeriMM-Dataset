`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [159:0] cv_in;
    reg [6:0] round;
    reg [31:0] w;
    wire [159:0] cv_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cv_in(cv_in),
        .round(round),
        .w(w),
        .cv_out(cv_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Round 0 with standard IV", test_num);
        cv_in = {32'h67452301, 32'hEFCDAB89, 32'h98BADCFE, 32'h10325476, 32'hC3D2E1F0};
        w = 32'h00000000;
        round = 7'd0;






        #1;







        check_outputs(160'h859A67B367452301BBF36AE298BADCFE10325476);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Round 20 (Stage 2 XOR)", test_num);
        cv_in = 160'h0000000100000002000000040000000800000010;
        round = 7'd20;
        w = 32'h00000001;




        #1;





        check_outputs(160'h6ED9EBE000000001800000000000000400000008);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Round 40 (Stage 3 MAJ)", test_num);
        cv_in = 160'h00000000FFFFFFFFFFFFFFFF0000000000000000;
        round = 7'd40;
        w = 32'h00000000;



        #1;




        check_outputs(160'h8F1BBCDB00000000FFFFFFFFFFFFFFFF00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Round 60 (Stage 4 XOR)", test_num);
        cv_in = 160'h0000000000000001000000020000000400000008;
        round = 7'd60;
        w = 32'h00000000;



        #1;




        check_outputs(160'hCA62C1E500000000400000000000000200000004);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Round 19 Boundary Check", test_num);
        cv_in = 160'h0000000100000002000000040000000800000010;
        round = 7'd19;
        w = 32'h00000001;



        #1;




        check_outputs(160'h5A8279D200000001800000000000000400000008);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Round 79 Final Round", test_num);
        cv_in = 160'h0000000000000000000000000000000000000000;
        round = 7'd79;
        w = 32'hFFFFFFFF;


        #1;



        check_outputs(160'hCA62C1D500000000000000000000000000000000);
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
        input [159:0] expected_cv_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cv_out === (expected_cv_out ^ cv_out ^ expected_cv_out)) begin
                $display("PASS");
                $display("  Outputs: cv_out=%h",
                         cv_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cv_out=%h",
                         expected_cv_out);
                $display("  Got:      cv_out=%h",
                         cv_out);
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
