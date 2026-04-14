`timescale 1ns/1ps

module and_gate_pipe_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] and_a;
    reg [7:0] and_b;
    reg clk;
    reg i_en;
    reg rst_n;
    wire o_en;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_gate_pipe_8bit dut (
        .and_a(and_a),
        .and_b(and_b),
        .clk(clk),
        .i_en(i_en),
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
            and_a = 8'h0;
            and_b = 8'h0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND of 8'hFF and 8'hFF", test_num);
            reset_dut();

            @(posedge clk);
            i_en <= 1;
            and_a <= 8'hFF;
            and_b <= 8'hFF;

            @(posedge clk);
            i_en <= 0;


            wait(o_en == 1);
            #1 #1;
 check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND of 8'h00 and 8'hFF", test_num);
            reset_dut();

            @(posedge clk);
            i_en <= 1;
            and_a <= 8'h00;
            and_b <= 8'hFF;

            @(posedge clk);
            i_en <= 0;

            wait(o_en == 1);
            #1 #1;
 check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND of 8'hAA and 8'h55", test_num);
            reset_dut();

            @(posedge clk);
            i_en <= 1;
            and_a <= 8'hAA;
            and_b <= 8'h55;

            @(posedge clk);
            i_en <= 0;

            wait(o_en == 1);
            #1 #1;
 check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND of 8'hF0 and 8'hCC", test_num);
            reset_dut();

            @(posedge clk);
            i_en <= 1;
            and_a <= 8'hF0;
            and_b <= 8'hCC;

            @(posedge clk);
            i_en <= 0;

            wait(o_en == 1);
            #1 #1;
 check_outputs(1'b1, 8'hC0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND of 8'hC3 and 8'hA5", test_num);
            reset_dut();

            @(posedge clk);
            i_en <= 1;
            and_a <= 8'hC3;
            and_b <= 8'hA5;

            @(posedge clk);
            i_en <= 0;

            wait(o_en == 1);
            #1 #1;
 check_outputs(1'b1, 8'h81);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low (i_en=0) check", test_num);
            reset_dut();

            @(posedge clk);
            i_en <= 0;
            and_a <= 8'hFF;
            and_b <= 8'hFF;


            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(1'b0, result);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_gate_pipe_8bit Testbench");
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
        input [7:0] expected_result;
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
        $dumpvars(0,and_a, and_b, clk, i_en, rst_n, o_en, result);
    end

endmodule
