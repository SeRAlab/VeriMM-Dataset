`timescale 1ns/1ps

module fft_4point_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a0;
    reg [7:0] a1;
    reg [7:0] a2;
    reg [7:0] a3;
    reg [7:0] b0;
    reg [7:0] b1;
    reg [7:0] b2;
    reg [7:0] b3;
    wire [7:0] c0_imag;
    wire [7:0] c0_real;
    wire [7:0] c1_imag;
    wire [7:0] c1_real;
    wire [7:0] c2_imag;
    wire [7:0] c2_real;
    wire [7:0] c3_imag;
    wire [7:0] c3_real;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fft_4point dut (
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .c0_imag(c0_imag),
        .c0_real(c0_real),
        .c1_imag(c1_imag),
        .c1_real(c1_real),
        .c2_imag(c2_imag),
        .c2_real(c2_real),
        .c3_imag(c3_imag),
        .c3_real(c3_real)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All zeros", test_num);
            a0 = 8'h00; b0 = 8'h00; a1 = 8'h00; b1 = 8'h00;
            a2 = 8'h00; b2 = 8'h00; a3 = 8'h00; b3 = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unit impulse at x[0]", test_num);
            a0 = 8'h01; b0 = 8'h00; a1 = 8'h00; b1 = 8'h00;
            a2 = 8'h00; b2 = 8'h00; a3 = 8'h00; b3 = 8'h00;
            #1;

            check_outputs(8'h00, 8'h01, 8'h00, 8'h01, 8'h00, 8'h01, 8'h00, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Constant DC signal", test_num);
            a0 = 8'h0A; b0 = 8'h00; a1 = 8'h0A; b1 = 8'h00;
            a2 = 8'h0A; b2 = 8'h00; a3 = 8'h0A; b3 = 8'h00;

            #1;


            check_outputs(8'h00, 8'h28, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Bin 1 Signal", test_num);
            a0 = 8'h0A; b0 = 8'h00;
            a1 = 8'h00; b1 = 8'h0A;
            a2 = 8'hF6; b2 = 8'h00;
            a3 = 8'h00; b3 = 8'hF6;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h28, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Bin 2 Signal", test_num);
            a0 = 8'h0A; b0 = 8'h00;
            a1 = 8'hF6; b1 = 8'h00;
            a2 = 8'h0A; b2 = 8'h00;
            a3 = 8'hF6; b3 = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h28, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Arbitrary Complex Input", test_num);
            a0 = 8'h02; b0 = 8'h03;
            a1 = 8'h04; b1 = 8'hFF;
            a2 = 8'hFF; b2 = 8'h02;
            a3 = 8'h00; b3 = 8'h01;


            #1;



            check_outputs(8'h05, 8'h05, 8'hFD, 8'h01, 8'h05, 8'hFD, 8'h05, 8'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Summation Overflow (Wraparound)", test_num);
            a0 = 8'h64; b0 = 8'h00;
            a1 = 8'h64; b1 = 8'h00;
            a2 = 8'h00; b2 = 8'h00;
            a3 = 8'h00; b3 = 8'h00;

            #1;


            check_outputs(8'h00, 8'hC8, 8'h9C, 8'h64, 8'h00, 8'h00, 8'h64, 8'h64);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fft_4point Testbench");
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
        input [7:0] expected_c0_imag;
        input [7:0] expected_c0_real;
        input [7:0] expected_c1_imag;
        input [7:0] expected_c1_real;
        input [7:0] expected_c2_imag;
        input [7:0] expected_c2_real;
        input [7:0] expected_c3_imag;
        input [7:0] expected_c3_real;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c0_imag === (expected_c0_imag ^ c0_imag ^ expected_c0_imag) &&
                expected_c0_real === (expected_c0_real ^ c0_real ^ expected_c0_real) &&
                expected_c1_imag === (expected_c1_imag ^ c1_imag ^ expected_c1_imag) &&
                expected_c1_real === (expected_c1_real ^ c1_real ^ expected_c1_real) &&
                expected_c2_imag === (expected_c2_imag ^ c2_imag ^ expected_c2_imag) &&
                expected_c2_real === (expected_c2_real ^ c2_real ^ expected_c2_real) &&
                expected_c3_imag === (expected_c3_imag ^ c3_imag ^ expected_c3_imag) &&
                expected_c3_real === (expected_c3_real ^ c3_real ^ expected_c3_real)) begin
                $display("PASS");
                $display("  Outputs: c0_imag=%h, c0_real=%h, c1_imag=%h, c1_real=%h, c2_imag=%h, c2_real=%h, c3_imag=%h, c3_real=%h",
                         c0_imag, c0_real, c1_imag, c1_real, c2_imag, c2_real, c3_imag, c3_real);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0_imag=%h, c0_real=%h, c1_imag=%h, c1_real=%h, c2_imag=%h, c2_real=%h, c3_imag=%h, c3_real=%h",
                         expected_c0_imag, expected_c0_real, expected_c1_imag, expected_c1_real, expected_c2_imag, expected_c2_real, expected_c3_imag, expected_c3_real);
                $display("  Got:      c0_imag=%h, c0_real=%h, c1_imag=%h, c1_real=%h, c2_imag=%h, c2_real=%h, c3_imag=%h, c3_real=%h",
                         c0_imag, c0_real, c1_imag, c1_real, c2_imag, c2_real, c3_imag, c3_real);
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
