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
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs are zero", test_num);
        A = 4'd0; B = 4'd0; C = 4'd0;
        #1;

        check_outputs(4'b0000, 5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs at maximum (15)", test_num);
        A = 4'd15; B = 4'd15; C = 4'd15;


        #1;



        check_outputs(4'b1111, 5'b01111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bits at different positions (no carry)", test_num);
        A = 4'b0001; B = 4'b0010; C = 4'b0100;


        #1;



        check_outputs(4'b0000, 5'b00111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Carries generated in all positions", test_num);
        A = 4'b1011; B = 4'b0111; C = 4'b1101;





        #1;






        check_outputs(4'b1111, 5'b01101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed inputs (Sum bits zero)", test_num);
        A = 4'b1010; B = 4'b0101; C = 4'b1111;





        #1;






        check_outputs(4'b1111, 5'b00000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Specific bit patterns", test_num);
        A = 4'd10; B = 4'd5; C = 4'd3;





        #1;






        check_outputs(4'b0011, 5'b01100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: MSB carry check", test_num);
        A = 4'b1000; B = 4'b1100; C = 4'b1010;


        #1;



        check_outputs(4'b1000, 5'b01110);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bit patterns", test_num);
        A = 4'b1010; B = 4'b1010; C = 4'b1010;


        #1;



        check_outputs(4'b1010, 5'b01010);
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
