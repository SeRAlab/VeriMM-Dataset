`timescale 1ns/1ps

module barrel_shifter_128bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg i_en;
    reg rst_n;
    reg [6:0] shift_val;
    wire o_en;
    wire [127:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter_128bit dut (
        .clk(clk),
        .data_in(data_in),
        .i_en(i_en),
        .rst_n(rst_n),
        .shift_val(shift_val),
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
        data_in = 0;
        shift_val = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        @(posedge clk);
        #1;
        i_en = 1;
        data_in = 128'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_9999_8888;
        shift_val = 7'd0;
        @(posedge clk);
        #1;
        i_en = 0;
        repeat(LATENCY) @(posedge clk);
        #1;

        check_outputs(1'b1, 128'hFFFF_EEEE_DDDD_CCCC_BBBB_AAAA_9999_8888);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        #1;
        i_en = 1;
        data_in = 128'h1;
        shift_val = 7'd1;
        @(posedge clk);
        #1;
        i_en = 0;
        repeat(LATENCY) @(posedge clk);
        #1;

        check_outputs(1'b1, 128'h2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge clk);
        #1;
        i_en = 1;
        data_in = 128'hA;
        shift_val = 7'd4;
        @(posedge clk);
        #1;
        i_en = 0;
        repeat(LATENCY) @(posedge clk);
        #1;

        check_outputs(1'b1, 128'hA0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(posedge clk);
        #1;
        i_en = 1;
        data_in = 128'h1;
        shift_val = 7'd127;
        @(posedge clk);
        #1;
        i_en = 0;
        repeat(LATENCY) @(posedge clk);
        #1;

        check_outputs(1'b1, 128'h8000_0000_0000_0000_0000_0000_0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge clk);
        #1;
        i_en = 1;
        data_in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
        shift_val = 7'd127;
        @(posedge clk);
        #1;
        i_en = 0;
        repeat(LATENCY) @(posedge clk);

        #1;


        check_outputs(1'b1, 128'h8000_0000_0000_0000_0000_0000_0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        @(posedge clk);
        #1;
        i_en = 0;
        data_in = 128'hDEAD_BEEF;
        shift_val = 7'd8;
        @(posedge clk);
        #1;
        repeat(LATENCY) @(posedge clk);
        #1;

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
        $display("barrel_shifter_128bit Testbench");
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
        input [127:0] expected_result;
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
        $dumpvars(0,clk, data_in, i_en, rst_n, shift_val, o_en, result);
    end

endmodule
