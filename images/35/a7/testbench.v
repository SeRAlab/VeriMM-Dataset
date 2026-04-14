`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    reg [2:0] c;
    wire [2:0] carry;
    wire [4:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .a(a),
        .b(b),
        .c(c),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        a = 3'b000; b = 3'b000; c = 3'b000;

        #1;


        check_outputs(3'b000, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values", test_num);
        a = 3'b111; b = 3'b111; c = 3'b111;


        #1;



        check_outputs(3'b111, 5'd21);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones", test_num);
        a = 3'b001; b = 3'b001; c = 3'b001;


        #1;



        check_outputs(3'b001, 5'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Powers of Two (No Carry overlap)", test_num);
        a = 3'b100; b = 3'b010; c = 3'b001;


        #1;



        check_outputs(3'b000, 5'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Values (Overlapping bits)", test_num);
        a = 3'b011; b = 3'b101; c = 3'b110;



        #1;




        check_outputs(3'b111, 5'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Large Input", test_num);
        a = 3'b111; b = 3'b000; c = 3'b000;


        #1;



        check_outputs(3'b000, 5'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry in Mid-Bit Only", test_num);
        a = 3'b010; b = 3'b010; c = 3'b010;


        #1;



        check_outputs(3'b010, 5'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits", test_num);
        a = 3'b101; b = 3'b010; c = 3'b101;



        #1;




        check_outputs(3'b101, 5'd12);
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
        input [2:0] expected_carry;
        input [4:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%h, sum=%h",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%h, sum=%h",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%h, sum=%h",
                         carry, sum);
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
