`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [3:0] Carry;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .Carry(Carry),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'b0000; B = 4'b0000; C = 4'b0000;

            #1;


            check_outputs(4'h0, 5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'b1111; B = 4'b0000; C = 4'b0000;

            #1;


            check_outputs(4'h0, 5'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'b1111; B = 4'b1111; C = 4'b1111;

            #1;


            check_outputs(4'hF, 5'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'b1010; B = 4'b0101; C = 4'b0000;

            #1;


            check_outputs(4'h0, 5'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b1010; B = 4'b0101; C = 4'b1111;

            #1;


            check_outputs(4'hF, 5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b0111; B = 4'b0011; C = 4'b0001;


            #1;



            check_outputs(4'h3, 5'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b1000; B = 4'b1000; C = 4'b1000;


            #1;



            check_outputs(4'h8, 5'h08);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b1100; B = 4'b0110; C = 4'b0011;


            #1;



            check_outputs(4'h6, 5'h09);
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
        input [3:0] expected_Carry;
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Carry === (expected_Carry ^ Carry ^ expected_Carry) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Carry=%h, Sum=%h",
                         Carry, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry=%h, Sum=%h",
                         expected_Carry, expected_Sum);
                $display("  Got:      Carry=%h, Sum=%h",
                         Carry, Sum);
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
