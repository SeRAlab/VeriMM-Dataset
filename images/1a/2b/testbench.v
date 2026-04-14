`timescale 1ns/1ps

module matrix_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_multiplier dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 4'b0000;
        B = 4'b1111;
        $display("Test %0d: Zero matrix A * All-ones matrix B", test_num);

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'b1001;
        B = 4'b1001;
        $display("Test %0d: Identity matrix A * Identity matrix B", test_num);


        #1;



        check_outputs(16'h1001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'b1111;
        B = 4'b1111;
        $display("Test %0d: All-ones matrix A * All-ones matrix B", test_num);


        #1;



        check_outputs(16'h2222);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'b1001;
        B = 4'b1111;
        $display("Test %0d: Identity matrix A * All-ones matrix B", test_num);


        #1;



        check_outputs(16'h1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'b0110;
        B = 4'b1100;
        $display("Test %0d: Matrix A (Exchange) * Matrix B pattern", test_num);





        #1;






        check_outputs(16'h0011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'b0111;
        B = 4'b1011;
        $display("Test %0d: Complex pattern multiplication", test_num);





        #1;






        check_outputs(16'h1121);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'b1101;
        B = 4'b0110;
        $display("Test %0d: Pattern with zero products", test_num);





        #1;






        check_outputs(16'h1110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_multiplier Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
