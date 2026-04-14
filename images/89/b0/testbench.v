`timescale 1ns/1ps

module or_gate_pipe_12bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg [11:0] or_a;
    reg [11:0] or_b;
    reg rst_n;
    wire o_en;
    wire [11:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    or_gate_pipe_12bit dut (
        .clk(clk),
        .i_en(i_en),
        .or_a(or_a),
        .or_b(or_b),
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
            rst_n = 1'b0;
            i_en = 1'b0;
            or_a = 12'h0;
            or_b = 12'h0;
            repeat (2) @(posedge clk);
            #1 rst_n = 1'b1;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            or_a = 12'h000;
            or_b = 12'h000;
            i_en = 1'b1;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b1, 12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            or_a = 12'hFFF;
            or_b = 12'h000;
            i_en = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            or_a = 12'hAAA;
            or_b = 12'h555;
            i_en = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 12'hFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            or_a = 12'h123;
            or_b = 12'h456;
            i_en = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, (12'h123 | 12'h456));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            or_a = 12'h800;
            or_b = 12'h001;
            i_en = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 12'h801);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            or_a = 12'hFFF;
            or_b = 12'hFFF;
            i_en = 1'b0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 12'hFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            or_a = 12'hA0C;
            or_b = 12'h0B0;
            i_en = 1'b1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 12'hABC);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            or_a = 12'hFFF;
            or_b = 12'hFFF;
            i_en = 1'b1;
            @(posedge clk);

            rst_n = 1'b0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 12'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("or_gate_pipe_12bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [11:0] expected_result;
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
        $dumpvars(0,clk, i_en, or_a, or_b, rst_n, o_en, result);
    end

endmodule
