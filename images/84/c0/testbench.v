`timescale 1ns/1ps

module relation_check_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] input_bits;
    wire [4:0] and_left;
    wire [4:0] or_right;
    wire [5:0] xor_cycle;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    relation_check dut (
        .input_bits(input_bits),
        .and_left(and_left),
        .or_right(or_right),
        .xor_cycle(xor_cycle)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            input_bits = 6'b000000;

            #1;


            check_outputs(5'h00, 5'h00, 6'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            input_bits = 6'b111111;



            #1;




            check_outputs(5'h1F, 5'h1F, 6'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits (101010)", test_num);
            input_bits = 6'b101010;




            #1;





            check_outputs(5'h00, 5'h1F, 6'h3F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 011001", test_num);
            input_bits = 6'b011001;



            #1;




            check_outputs(5'h08, 5'h1D, 6'h35);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 110011", test_num);
            input_bits = 6'b110011;



            #1;




            check_outputs(5'h11, 5'h1B, 6'h0A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit Moving (001110)", test_num);
            input_bits = 6'b001110;



            #1;




            check_outputs(5'h06, 5'h0F, 6'h09);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge Wrapping Check (100001)", test_num);
            input_bits = 6'b100001;



            #1;




            check_outputs(5'h00, 5'h11, 6'h11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Pattern 101101", test_num);
            input_bits = 6'b101101;



            #1;




            check_outputs(5'h04, 5'h1F, 6'h1B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("relation_check Testbench");
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
        input [4:0] expected_and_left;
        input [4:0] expected_or_right;
        input [5:0] expected_xor_cycle;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_left === (expected_and_left ^ and_left ^ expected_and_left) &&
                expected_or_right === (expected_or_right ^ or_right ^ expected_or_right) &&
                expected_xor_cycle === (expected_xor_cycle ^ xor_cycle ^ expected_xor_cycle)) begin
                $display("PASS");
                $display("  Outputs: and_left=%h, or_right=%h, xor_cycle=%h",
                         and_left, or_right, xor_cycle);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_left=%h, or_right=%h, xor_cycle=%h",
                         expected_and_left, expected_or_right, expected_xor_cycle);
                $display("  Got:      and_left=%h, or_right=%h, xor_cycle=%h",
                         and_left, or_right, xor_cycle);
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
