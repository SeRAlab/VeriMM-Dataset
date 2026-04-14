`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] inv_a;
    wire [7:0] inv_b;
    wire [7:0] inv_c;
    wire [7:0] inv_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .inv_a(inv_a),
        .inv_b(inv_b),
        .inv_c(inv_c),
        .inv_d(inv_d)
    );
    task testcase001;

        begin
            test_num = 1;


            a = 8'd1; b = 8'd0; c = 8'd0; d = 8'd1;
            $display("\nTest %0d: Identity Matrix", test_num);


            #1;



            check_outputs(8'h01, 8'h00, 8'h00, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;


            a = 8'd7; b = 8'd3; c = 8'd2; d = 8'd1;
            $display("\nTest %0d: Positive elements, Det=1", test_num);


            #1;



            check_outputs(8'h01, 8'hFD, 8'hFE, 8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;


            a = 8'd1; b = 8'd2; c = 8'd1; d = 8'd1;
            $display("\nTest %0d: Determinant = -1", test_num);


            #1;



            check_outputs(8'hFF, 8'h02, 8'h01, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;


            a = 8'hFE; b = 8'hFB; c = 8'hFF; d = 8'hFD;
            $display("\nTest %0d: All negative elements, Det=1", test_num);


            #1;



            check_outputs(8'hFD, 8'h05, 8'h01, 8'hFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;


            a = 8'd0; b = 8'd1; c = 8'd1; d = 8'd0;
            $display("\nTest %0d: Swap/Permutation Matrix", test_num);


            #1;



            check_outputs(8'h00, 8'h01, 8'h01, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;


            a = 8'd2; b = 8'd0; c = 8'd0; d = 8'd2;
            $display("\nTest %0d: Integer Truncation Case (Det=4)", test_num);


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
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
        input [7:0] expected_inv_a;
        input [7:0] expected_inv_b;
        input [7:0] expected_inv_c;
        input [7:0] expected_inv_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inv_a === (expected_inv_a ^ inv_a ^ expected_inv_a) &&
                expected_inv_b === (expected_inv_b ^ inv_b ^ expected_inv_b) &&
                expected_inv_c === (expected_inv_c ^ inv_c ^ expected_inv_c) &&
                expected_inv_d === (expected_inv_d ^ inv_d ^ expected_inv_d)) begin
                $display("PASS");
                $display("  Outputs: inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h",
                         inv_a, inv_b, inv_c, inv_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h",
                         expected_inv_a, expected_inv_b, expected_inv_c, expected_inv_d);
                $display("  Got:      inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h",
                         inv_a, inv_b, inv_c, inv_d);
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
