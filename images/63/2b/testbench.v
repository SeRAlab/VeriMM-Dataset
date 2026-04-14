`timescale 1ns/1ps

module nor_gate_pipe_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg [3:0] nor_a;
    reg [3:0] nor_b;
    reg rst_n;
    wire o_en;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nor_gate_pipe_4bit dut (
        .clk(clk),
        .i_en(i_en),
        .nor_a(nor_a),
        .nor_b(nor_b),
        .rst_n(rst_n),
        .o_en(o_en),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_en = 0;
            nor_a = 4'b0;
            nor_b = 4'b0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            nor_a = 4'b0000;
            nor_b = 4'b0000;
            i_en = 1;
            @(posedge clk);
            i_en = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            nor_a = 4'b1111;
            nor_b = 4'b1111;
            i_en = 1;
            @(posedge clk);
            i_en = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complementary Inputs", test_num);
            reset_dut();
            nor_a = 4'b1010;
            nor_b = 4'b0101;
            i_en = 1;
            @(posedge clk);
            i_en = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Partial Bit Overlap", test_num);
            reset_dut();
            nor_a = 4'b0110;
            nor_b = 4'b0001;
            i_en = 1;
            @(posedge clk);
            i_en = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disable Enable Signal", test_num);
            reset_dut();
            nor_a = 4'b0000;
            nor_b = 4'b0000;
            i_en = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous Pipelined Inputs", test_num);
            reset_dut();


            nor_a = 4'b1001;
            nor_b = 4'b0000;
            i_en = 1;
            @(posedge clk);


            nor_a = 4'b1100;
            nor_b = 4'b0011;
            i_en = 1;
            #1 #1;
 check_outputs(1'b1, 4'b0110);
            @(posedge clk);


            i_en = 0;
            #1 #1;
 check_outputs(1'b1, 4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nor_gate_pipe_4bit Testbench");
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
        input expected_o_en;
        input [3:0] expected_result;
        begin
            if (expected_o_en === (expected_o_en ^ o_en ^ expected_o_en) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_en=%b, result=%h",
                         o_en, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_en=%b, result=%h",
                         expected_o_en, expected_result);
                $display("  Got:      o_en=%b, result=%h",
                         o_en, result);
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
        $dumpvars(0,clk, i_en, nor_a, nor_b, rst_n, o_en, result);
    end

endmodule
