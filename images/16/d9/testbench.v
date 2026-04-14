`timescale 1ns/1ps

module pipeline_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg clk;
    reg rst;
    wire [7:0] S2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .clk(clk),
        .rst(rst),
        .S2(S2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            C = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            C = 8'd5;


            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs", test_num);
            reset_dut();
            A = 8'd0;
            B = 8'd0;
            C = 8'd0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum 8-bit Result", test_num);
            reset_dut();
            A = 8'd100;
            B = 8'd100;
            C = 8'd55;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Case (300 mod 256)", test_num);
            reset_dut();
            A = 8'd150;
            B = 8'd100;
            C = 8'd50;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Operand at Max", test_num);
            reset_dut();
            A = 8'hFF;
            B = 8'd0;
            C = 8'd0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large C value", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd10;
            C = 8'd200;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd220);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            reset_dut();
            A = 8'hAA;
            B = 8'h55;
            C = 8'h01;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_adder Testbench");
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
        input [7:0] expected_S2;
        begin
            if (expected_S2 === (expected_S2 ^ S2 ^ expected_S2)) begin
                $display("PASS");
                $display("  Outputs: S2=%h",
                         S2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S2=%h",
                         expected_S2);
                $display("  Got:      S2=%h",
                         S2);
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
        $dumpvars(0,A, B, C, clk, rst, S2);
    end

endmodule
