`timescale 1ns/1ps

module xnor_gate_pipe_20bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg rst_n;
    reg [19:0] xnor_a;
    reg [19:0] xnor_b;
    wire o_en;
    wire [19:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xnor_gate_pipe_20bit dut (
        .clk(clk),
        .i_en(i_en),
        .rst_n(rst_n),
        .xnor_a(xnor_a),
        .xnor_b(xnor_b),
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
        xnor_a = 0;
        xnor_b = 0;
        repeat(2) @(posedge clk);
        #1;
        rst_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: All Zeros...");
        reset_dut();
        xnor_a = 20'h00000;
        xnor_b = 20'h00000;
        i_en = 1;
        @(posedge clk);
        i_en = 0;


        wait(o_en == 1);
        #1;

        check_outputs(1'b1, 20'hFFFFF);
        @(posedge clk);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: All Ones...");
        reset_dut();
        xnor_a = 20'hFFFFF;
        xnor_b = 20'hFFFFF;
        i_en = 1;
        @(posedge clk);
        i_en = 0;

        wait(o_en == 1);
        #1;

        check_outputs(1'b1, 20'hFFFFF);
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Complementary Patterns...");
        reset_dut();
        xnor_a = 20'hAAAAA;
        xnor_b = 20'h55555;
        i_en = 1;
        @(posedge clk);
        i_en = 0;

        wait(o_en == 1);
        #1;

        check_outputs(1'b1, 20'h00000);
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Mixed Pattern...");
        reset_dut();




        xnor_a = 20'h12345;
        xnor_b = 20'h54321;
        i_en = 1;
        @(posedge clk);
        i_en = 0;

        wait(o_en == 1);
        #1;

        check_outputs(1'b1, 20'hB9F9B);
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Consecutive Operations...");
        reset_dut();


        xnor_a = 20'hF0F0F;
        xnor_b = 20'h0F0F0;
        i_en = 1;
        @(posedge clk);


        xnor_a = 20'hCC33C;
        xnor_b = 20'hCC33C;
        i_en = 1;
        @(posedge clk);
        i_en = 0;


        wait(o_en == 1);
        #1;

        check_outputs(1'b1, 20'h00000);


        @(posedge clk);
        #1;

        check_outputs(1'b1, 20'hFFFFF);
        @(posedge clk);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Reset behavior...");
        reset_dut();
        xnor_a = 20'hFFFFF;
        xnor_b = 20'hFFFFF;
        i_en = 1;
        @(posedge clk);
        rst_n = 0;
        @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b0, 20'h00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xnor_gate_pipe_20bit Testbench");
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
        input [19:0] expected_result;
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
        $dumpvars(0,clk, i_en, rst_n, xnor_a, xnor_b, o_en, result);
    end

endmodule
