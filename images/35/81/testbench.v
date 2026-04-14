`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [3:0] CARRY;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .CARRY(CARRY),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000;
        B = 4'b0000;
        C = 4'b0000;
        $display("Test %0d: All Zeros (A=0, B=0, C=0)", test_num);

        #1;


        check_outputs(4'b0000, 5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b0001;
        B = 4'b0010;
        C = 4'b0100;
        $display("Test %0d: Single Bits (A=1, B=2, C=4)", test_num);


        #1;



        check_outputs(4'b0000, 5'b00111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1111;
        B = 4'b1111;
        C = 4'b1111;
        $display("Test %0d: All Ones (A=F, B=F, C=F)", test_num);


        #1;



        check_outputs(4'b1111, 5'b01111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b1010;
        B = 4'b0110;
        C = 4'b0011;
        $display("Test %0d: Mixed Bits (A=A, B=6, C=3)", test_num);





        #1;






        check_outputs(4'b0010, 5'b01111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b0101;
        B = 4'b1010;
        C = 4'b0101;
        $display("Test %0d: Checkerboard Pattern (A=5, B=A, C=5)", test_num);


        #1;



        check_outputs(4'b0101, 5'b01010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1100;
        B = 4'b1000;
        C = 4'b1111;
        $display("Test %0d: High Bit Concentration (A=C, B=8, C=F)", test_num);





        #1;






        check_outputs(4'b1100, 5'b01011);
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
        input [3:0] expected_CARRY;
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CARRY === (expected_CARRY ^ CARRY ^ expected_CARRY) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY=%h, SUM=%h",
                         CARRY, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY=%h, SUM=%h",
                         expected_CARRY, expected_SUM);
                $display("  Got:      CARRY=%h, SUM=%h",
                         CARRY, SUM);
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
