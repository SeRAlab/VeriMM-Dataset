`timescale 1ns/1ps

module bitwise_relation_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] in_vector;
    wire [8:0] res_left;
    wire [8:0] res_right;
    wire [9:0] res_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_relation dut (
        .in_vector(in_vector),
        .res_left(res_left),
        .res_right(res_right),
        .res_xor(res_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in_vector = 10'h000;
            #1;

            check_outputs(9'h000, 9'h000, 10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            in_vector = 10'h3FF;
            #1;

            check_outputs(9'h1FF, 9'h1FF, 10'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (0101...)", test_num);
            in_vector = 10'h155;
            #1;

            check_outputs(9'h000, 9'h1FF, 10'h3FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (1010...)", test_num);
            in_vector = 10'h2AA;
            #1;

            check_outputs(9'h000, 9'h1FF, 10'h3FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Adjacent Ones (LSB side)", test_num);
            in_vector = 10'h003;

            #1;


            check_outputs(9'h001, 9'h003, 10'h002);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Adjacent Ones (MSB side)", test_num);
            in_vector = 10'h300;

            #1;


            check_outputs(9'h100, 9'h180, 10'h280);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap Around Bit Pattern", test_num);
            in_vector = 10'h201;

            #1;


            check_outputs(9'h000, 9'h101, 10'h101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sparse Single Bits", test_num);
            in_vector = 10'h124;

            #1;


            check_outputs(9'h000, 9'h1B6, 10'h1B6);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Almost All Ones", test_num);
            in_vector = 10'h3FE;



            #1;




            check_outputs(9'h1FE, 9'h1FF, 10'h201);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Block Pattern", test_num);
            in_vector = 10'h0F0;



            #1;




            check_outputs(9'h070, 9'h0F8, 10'h088);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_relation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [8:0] expected_res_left;
        input [8:0] expected_res_right;
        input [9:0] expected_res_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res_left === (expected_res_left ^ res_left ^ expected_res_left) &&
                expected_res_right === (expected_res_right ^ res_right ^ expected_res_right) &&
                expected_res_xor === (expected_res_xor ^ res_xor ^ expected_res_xor)) begin
                $display("PASS");
                $display("  Outputs: res_left=%h, res_right=%h, res_xor=%h",
                         res_left, res_right, res_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res_left=%h, res_right=%h, res_xor=%h",
                         expected_res_left, expected_res_right, expected_res_xor);
                $display("  Got:      res_left=%h, res_right=%h, res_xor=%h",
                         res_left, res_right, res_xor);
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
