`timescale 1ns/1ps

module fpu_add_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [63:0] opa;
    reg [63:0] opb;
    reg rst;
    wire [10:0] exponent_2;
    wire sign;
    wire [55:0] sum_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fpu_add dut (
        .clk(clk),
        .enable(enable),
        .opa(opa),
        .opb(opb),
        .rst(rst),
        .exponent_2(exponent_2),
        .sign(sign),
        .sum_2(sum_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            opa = 64'd0;
            opb = 64'd0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: 1.0 + 1.0", test_num);
            opa = 64'h3FF0000000000000;
            opb = 64'h3FF0000000000000;
            enable = 1;
            #10;
            enable = 0;
            #10;

            #1;


            check_outputs(11'h400, 1'b0, 55'h40000000000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: 1.0 + 0.5", test_num);
            opa = 64'h3FF0000000000000;
            opb = 64'h3FE0000000000000;
            enable = 1;
            #10;
            enable = 0;
            #10;

            #1;


            check_outputs(11'h3FF, 1'b0, 55'h60000000000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: 2.0 + 3.0", test_num);
            opa = 64'h4000000000000000;
            opb = 64'h4008000000000000;
            enable = 1;
            #10;
            enable = 0;
            #10;

            #1;


            check_outputs(11'h401, 1'b0, 55'h50000000000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: 0.0 + 0.0", test_num);
            opa = 64'h0000000000000000;
            opb = 64'h0000000000000000;
            enable = 1;
            #10;
            enable = 0;
            #10;
            #1;

            check_outputs(11'h000, 1'b0, 55'h00000000000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: -2.0 + -2.0", test_num);
            opa = 64'hC000000000000000;
            opb = 64'hC000000000000000;
            enable = 1;
            #10;
            enable = 0;
            #10;

            #1;


            check_outputs(11'h401, 1'b1, 55'h40000000000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: 1.0 + -1.0", test_num);
            opa = 64'h3FF0000000000000;
            opb = 64'hBFF0000000000000;
            enable = 1;
            #10;
            enable = 0;
            #10;
            #1;

            check_outputs(11'h000, 1'b0, 55'h00000000000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: 2.0 + 2^-50", test_num);
            opa = 64'h4000000000000000;
            opb = 64'h3CD0000000000000;
            enable = 1;
            #10;
            enable = 0;
            #10;


            #1;



            check_outputs(11'h400, 1'b0, 55'h40000000000008);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fpu_add Testbench");
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
        input [10:0] expected_exponent_2;
        input expected_sign;
        input [55:0] expected_sum_2;
        begin
            if (expected_exponent_2 === (expected_exponent_2 ^ exponent_2 ^ expected_exponent_2) &&
                expected_sign === (expected_sign ^ sign ^ expected_sign) &&
                expected_sum_2 === (expected_sum_2 ^ sum_2 ^ expected_sum_2)) begin
                $display("PASS");
                $display("  Outputs: exponent_2=%h, sign=%b, sum_2=%h",
                         exponent_2, sign, sum_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exponent_2=%h, sign=%b, sum_2=%h",
                         expected_exponent_2, expected_sign, expected_sum_2);
                $display("  Got:      exponent_2=%h, sign=%b, sum_2=%h",
                         exponent_2, sign, sum_2);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, enable, opa, opb, rst, exponent_2, sign, sum_2);
    end

endmodule
