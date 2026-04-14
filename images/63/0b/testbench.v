`timescale 1ns/1ps

module adder_pipe_64bit_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] adda;
    reg [63:0] addb;
    reg clk;
    reg i_en;
    reg rst_n;
    wire o_en;
    wire [64:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_pipe_64bit dut (
        .adda(adda),
        .addb(addb),
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
        adda = 0;
        addb = 0;
        i_en = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic addition (10 + 20)", test_num);

        @(posedge clk);
        #1;
        adda = 64'd10;
        addb = 64'd20;
        i_en = 1;

        @(posedge clk);
        #1;
        i_en = 0;


        repeat(3) @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, 65'd30);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Carry out check (2^64-1 + 1)", test_num);

        @(posedge clk);
        #1;
        adda = 64'hFFFF_FFFF_FFFF_FFFF;
        addb = 64'd1;
        i_en = 1;

        @(posedge clk);
        #1;
        i_en = 0;

        repeat(3) @(posedge clk);
        #2;


        #1;



        check_outputs(1'b1, 65'h1_0000_0000_0000_0000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Addition with zero (0 + 0)", test_num);

        @(posedge clk);
        #1;
        adda = 64'h0;
        addb = 64'h0;
        i_en = 1;

        @(posedge clk);
        #1;
        i_en = 0;

        repeat(3) @(posedge clk);
        #2;

        #1;


        check_outputs(1'b1, 65'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: All bits set (2^64-1 + 2^64-1)", test_num);

        @(posedge clk);
        #1;
        adda = 64'hFFFF_FFFF_FFFF_FFFF;
        addb = 64'hFFFF_FFFF_FFFF_FFFF;
        i_en = 1;

        @(posedge clk);
        #1;
        i_en = 0;

        repeat(3) @(posedge clk);
        #2;


        #1;



        check_outputs(1'b1, 65'h1_FFFF_FFFF_FFFF_FFFE);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Alternating bit patterns", test_num);

        @(posedge clk);
        #1;
        adda = 64'hAAAA_AAAA_AAAA_AAAA;
        addb = 64'h5555_5555_5555_5555;
        i_en = 1;

        @(posedge clk);
        #1;
        i_en = 0;

        repeat(3) @(posedge clk);
        #2;


        #1;



        check_outputs(1'b1, 65'h0_FFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Multi-stage carry propagation", test_num);

        @(posedge clk);
        #1;
        adda = 64'h1234_5678_9ABC_DEF0;
        addb = 64'hEDCB_A987_6543_210F;
        i_en = 1;

        @(posedge clk);
        #1;
        i_en = 0;

        repeat(3) @(posedge clk);
        #2;


        #1;



        check_outputs(1'b1, 65'h0_FFFF_FFFF_FFFF_FFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_pipe_64bit Testbench");
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
        input [64:0] expected_result;
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
        $dumpvars(0,adda, addb, clk, i_en, rst_n, o_en, result);
    end

endmodule
