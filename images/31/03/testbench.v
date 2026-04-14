`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [4:0] C_out;
    wire [4:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .C_out(C_out),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        A = 4'b0000; B = 4'b0000; C = 4'b0000;

        #1;


        check_outputs(5'h00, 5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Ones (Max Values)", test_num);
        A = 4'hF; B = 4'hF; C = 4'hF;



        #1;




        check_outputs(5'h1E, 5'h0F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Complementary A and B", test_num);
        A = 4'b1010; B = 4'b0101; C = 4'b0000;

        #1;


        check_outputs(5'h00, 5'h0F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: High bit propagation", test_num);
        A = 4'h8; B = 4'h8; C = 4'h8;


        #1;



        check_outputs(5'h10, 5'h08);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Random pattern 1", test_num);
        A = 4'h7; B = 4'h3; C = 4'h1;




        #1;





        check_outputs(5'h06, 5'h05);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Random pattern 2", test_num);
        A = 4'hE; B = 4'h7; C = 4'hB;







        #1;








        check_outputs(5'h1E, 5'h02);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_save_adder Testbench");
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
        input [4:0] expected_C_out;
        input [4:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C_out=%h, S=%h",
                         C_out, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%h, S=%h",
                         expected_C_out, expected_S);
                $display("  Got:      C_out=%h, S=%h",
                         C_out, S);
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
