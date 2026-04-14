`timescale 1ns/1ps

module bitwise_comp_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [6:0] left_and;
    wire [6:0] right_or;
    wire [7:0] xor_wrap;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_comp dut (
        .data_in(data_in),
        .left_and(left_and),
        .right_or(right_or),
        .xor_wrap(xor_wrap)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros (8'h00)", test_num);
        data_in = 8'h00;
        #1;

        check_outputs(7'h00, 7'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All ones (8'hFF)", test_num);
        data_in = 8'hFF;
        #1;

        check_outputs(7'h7F, 7'h7F, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Alternating pattern (8'h55)", test_num);
        data_in = 8'h55;



        #1;




        check_outputs(7'h00, 7'h7F, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Alternating pattern (8'hAA)", test_num);
        data_in = 8'hAA;



        #1;




        check_outputs(7'h00, 7'h7F, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Single bit LSB (8'h01)", test_num);
        data_in = 8'h01;



        #1;




        check_outputs(7'h00, 7'h01, 8'h81);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Single bit MSB (8'h80)", test_num);
        data_in = 8'h80;



        #1;




        check_outputs(7'h00, 7'h40, 8'hC0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Block patterns (8'h33)", test_num);
        data_in = 8'h33;



        #1;




        check_outputs(7'h11, 7'h3B, 8'hAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Edge pattern (8'hC0)", test_num);
        data_in = 8'hC0;



        #1;




        check_outputs(7'h40, 7'h60, 8'hA0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_comp Testbench");
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
        input [6:0] expected_left_and;
        input [6:0] expected_right_or;
        input [7:0] expected_xor_wrap;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_left_and === (expected_left_and ^ left_and ^ expected_left_and) &&
                expected_right_or === (expected_right_or ^ right_or ^ expected_right_or) &&
                expected_xor_wrap === (expected_xor_wrap ^ xor_wrap ^ expected_xor_wrap)) begin
                $display("PASS");
                $display("  Outputs: left_and=%h, right_or=%h, xor_wrap=%h",
                         left_and, right_or, xor_wrap);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left_and=%h, right_or=%h, xor_wrap=%h",
                         expected_left_and, expected_right_or, expected_xor_wrap);
                $display("  Got:      left_and=%h, right_or=%h, xor_wrap=%h",
                         left_and, right_or, xor_wrap);
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
