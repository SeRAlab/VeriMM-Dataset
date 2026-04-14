`timescale 1ns/1ps

module AddRoundKey_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg reset;
    reg [127:0] round_key;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AddRoundKey dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .round_key(round_key),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 0;
        round_key = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power-on Reset", test_num);

        reset = 1;
        data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        round_key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(128'h0);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Property (Data ^ 0)", test_num);
        reset_dut();
        data_in = 128'hABCDEFFEDCBA98765432101234567890;
        round_key = 128'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hABCDEFFEDCBA98765432101234567890);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Self-Inverse Property (Data ^ Data)", test_num);
        reset_dut();
        data_in = 128'h55555555AAAAAAA55555555AAAAAAAAA;
        round_key = 128'h55555555AAAAAAA55555555AAAAAAAAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones Pattern", test_num);
        reset_dut();
        data_in = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        round_key = 128'h55555555555555555555555555555555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Typical AES Pattern", test_num);
        reset_dut();



        data_in   = 128'h3243f6a8885a308d313198a2e0370734;
        round_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h193de3be00f4e22b9ac68d2ae9f84808);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise Toggle", test_num);
        reset_dut();
        data_in   = 128'hF0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0;
        round_key = 128'h0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AddRoundKey Testbench");
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
        input [127:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, round_key, data_out);
    end

endmodule
