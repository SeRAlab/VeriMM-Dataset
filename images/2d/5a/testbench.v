`timescale 1ns/1ps

module matrix_factorization_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] input_matrix;
    wire [31:0] item_matrix;
    wire [31:0] user_matrix;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_factorization dut (
        .input_matrix(input_matrix),
        .item_matrix(item_matrix),
        .user_matrix(user_matrix)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros Matrix", test_num);
        input_matrix = 64'h0000_0000_0000_0000;


        #1;



        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Max (0xF) Matrix", test_num);
        input_matrix = 64'hFFFF_FFFF_FFFF_FFFF;


        #1;



        check_outputs(32'h0F0F0F0F, 32'h0F0F0F0F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Vertical Stripes", test_num);
        input_matrix = 64'h1234_1234_1234_1234;
        #1;

        check_outputs(32'h01020304, 32'h02020202);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Horizontal Stripes", test_num);
        input_matrix = 64'h4444_3333_2222_1111;
        #1;

        check_outputs(32'h02020202, 32'h04030201);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sparse Diagonal Matrix", test_num);
        input_matrix = 64'h8000_0800_0080_0008;
        #1;

        check_outputs(32'h02020202, 32'h02020202);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Varied Sequential Matrix", test_num);
        input_matrix = 64'h0123_4567_89AB_CDEF;
        #1;

        check_outputs(32'h06070809, 32'h0105090D);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_factorization Testbench");
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
        input [31:0] expected_item_matrix;
        input [31:0] expected_user_matrix;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_item_matrix === (expected_item_matrix ^ item_matrix ^ expected_item_matrix) &&
                expected_user_matrix === (expected_user_matrix ^ user_matrix ^ expected_user_matrix)) begin
                $display("PASS");
                $display("  Outputs: item_matrix=%h, user_matrix=%h",
                         item_matrix, user_matrix);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: item_matrix=%h, user_matrix=%h",
                         expected_item_matrix, expected_user_matrix);
                $display("  Got:      item_matrix=%h, user_matrix=%h",
                         item_matrix, user_matrix);
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
