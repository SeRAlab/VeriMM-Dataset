`timescale 1ns/1ps

module quarter_round_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_a;
    reg [31:0] input_b;
    reg [31:0] input_c;
    reg [31:0] input_d;
    wire [31:0] output_a;
    wire [31:0] output_b;
    wire [31:0] output_c;
    wire [31:0] output_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quarter_round dut (
        .input_a(input_a),
        .input_b(input_b),
        .input_c(input_c),
        .input_d(input_d),
        .output_a(output_a),
        .output_b(output_b),
        .output_c(output_c),
        .output_d(output_d)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            input_a = 32'h00000000;
            input_b = 32'h00000000;
            input_c = 32'h00000000;
            input_d = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimal Inputs", test_num);
            input_a = 32'h00000001;
            input_b = 32'h00000001;
            input_c = 32'h00000001;
            input_d = 32'h00000001;





            #1;






            check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            input_a = 32'hffffffff;
            input_b = 32'hffffffff;
            input_c = 32'hffffffff;
            input_d = 32'hffffffff;
            #1;

            check_outputs(32'h0000fffd, 32'h10018000, 32'h0200fcff, 32'h01fffd00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Hex Pattern", test_num);
            input_a = 32'h11111111;
            input_b = 32'h01020304;
            input_c = 32'h9b8d6f43;
            input_d = 32'h01234567;
            #1;

            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            input_a = 32'haaaaaaaa;
            input_b = 32'h55555555;
            input_c = 32'haaaaaaaa;
            input_d = 32'h55555555;
            #1;

            check_outputs(32'h75555554, 32'hb2222212, 32'h97777766, 32'h40000004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rotation Boundary Test", test_num);
            input_a = 32'h80000000;
            input_b = 32'h80000000;
            input_c = 32'h00000000;
            input_d = 32'h00000000;
            #1;

            check_outputs(32'h00000001, 32'h00002000, 32'h00010001, 32'h00010100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quarter_round Testbench");
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
        input [31:0] expected_output_a;
        input [31:0] expected_output_b;
        input [31:0] expected_output_c;
        input [31:0] expected_output_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_a === (expected_output_a ^ output_a ^ expected_output_a) &&
                expected_output_b === (expected_output_b ^ output_b ^ expected_output_b) &&
                expected_output_c === (expected_output_c ^ output_c ^ expected_output_c) &&
                expected_output_d === (expected_output_d ^ output_d ^ expected_output_d)) begin
                $display("PASS");
                $display("  Outputs: output_a=%h, output_b=%h, output_c=%h, output_d=%h",
                         output_a, output_b, output_c, output_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_a=%h, output_b=%h, output_c=%h, output_d=%h",
                         expected_output_a, expected_output_b, expected_output_c, expected_output_d);
                $display("  Got:      output_a=%h, output_b=%h, output_c=%h, output_d=%h",
                         output_a, output_b, output_c, output_d);
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
