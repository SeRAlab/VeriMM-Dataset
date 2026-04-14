`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    wire [31:0] a_prim;
    wire [31:0] b_prim;
    wire [31:0] c_prim;
    wire [31:0] d_prim;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .a_prim(a_prim),
        .b_prim(b_prim),
        .c_prim(c_prim),
        .d_prim(d_prim)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Vector 1", test_num);
            a = 32'h11111111;
            b = 32'h01020304;
            c = 32'h9b8d6f43;
            d = 32'h01234567;


            #1;



            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MSB Boundary", test_num);
            a = 32'h80000000;
            b = 32'h80000000;
            c = 32'h80000000;
            d = 32'h80000000;

            #1;


            check_outputs(32'h08000000, 32'h40400444, 32'h80808008, 32'h00800008);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            a = 32'hffffffff;
            b = 32'hffffffff;
            c = 32'hffffffff;
            d = 32'hffffffff;




            #1;





            check_outputs(32'hffffedfd, 32'h89808090, 32'hedecfefe, 32'hedecffff);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit Prop", test_num);
            a = 32'h00000001;
            b = 32'h00000001;
            c = 32'h00000001;
            d = 32'h00000001;

            #1;


            check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_a_prim;
        input [31:0] expected_b_prim;
        input [31:0] expected_c_prim;
        input [31:0] expected_d_prim;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_prim === (expected_a_prim ^ a_prim ^ expected_a_prim) &&
                expected_b_prim === (expected_b_prim ^ b_prim ^ expected_b_prim) &&
                expected_c_prim === (expected_c_prim ^ c_prim ^ expected_c_prim) &&
                expected_d_prim === (expected_d_prim ^ d_prim ^ expected_d_prim)) begin
                $display("PASS");
                $display("  Outputs: a_prim=%h, b_prim=%h, c_prim=%h, d_prim=%h",
                         a_prim, b_prim, c_prim, d_prim);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_prim=%h, b_prim=%h, c_prim=%h, d_prim=%h",
                         expected_a_prim, expected_b_prim, expected_c_prim, expected_d_prim);
                $display("  Got:      a_prim=%h, b_prim=%h, c_prim=%h, d_prim=%h",
                         a_prim, b_prim, c_prim, d_prim);
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
