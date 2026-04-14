`timescale 1ns/1ps

module wbuidleint_tb;

    // Testbench signals (sequential circuit)
    reg i_busy;
    reg i_clk;
    reg [35:0] i_codword;
    reg i_cyc;
    reg i_int;
    reg i_stb;
    reg i_tx_busy;
    wire o_busy;
    wire [35:0] o_codword;
    wire o_stb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbuidleint dut (
        .i_busy(i_busy),
        .i_clk(i_clk),
        .i_codword(i_codword),
        .i_cyc(i_cyc),
        .i_int(i_int),
        .i_stb(i_stb),
        .i_tx_busy(i_tx_busy),
        .o_busy(o_busy),
        .o_codword(o_codword),
        .o_stb(o_stb)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_busy = 0;
            i_clk = 0;
            i_codword = 36'h0;
            i_cyc = 0;
            i_int = 0;
            i_stb = 0;
            i_tx_busy = 0;
            repeat(2) @(posedge i_clk);
            #1;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Normal Data Transmission", test_num);

            i_cyc = 1;
            i_stb = 1;
            i_codword = 36'hA_5A5A_5A5A;

            @(posedge i_clk);
            #1;


            #1;



            check_outputs(1'b0, 36'hA_5A5A_5A5A, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Interrupt Codeword Generation", test_num);

            i_int = 1;

            @(posedge i_clk);
            #1;



            #1;




            check_outputs(1'b1, 36'hF_0000_0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Downstream Busy (Backpressure)", test_num);

            i_tx_busy = 1;
            i_stb = 1;
            i_codword = 36'hB_EBEB_EBEB;

            @(posedge i_clk);
            #1;


            #1;



            check_outputs(1'b1, 36'hB_EBEB_EBEB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Idle Condition Handling", test_num);

            i_cyc = 1;
            i_stb = 0;


            repeat(11) @(posedge i_clk);
            #1;


            #1;



            check_outputs(1'b0, 36'h0_0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Cycle Termination logic", test_num);

            i_cyc = 0;
            i_stb = 1;
            i_codword = 36'hC_1234_5678;

            @(posedge i_clk);
            #1;


            #1;



            check_outputs(1'b0, 36'hC_1234_5678, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wbuidleint Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_o_busy;
        input [35:0] expected_o_codword;
        input expected_o_stb;
        begin
            if (expected_o_busy === (expected_o_busy ^ o_busy ^ expected_o_busy) &&
                expected_o_codword === (expected_o_codword ^ o_codword ^ expected_o_codword) &&
                expected_o_stb === (expected_o_stb ^ o_stb ^ expected_o_stb)) begin
                $display("PASS");
                $display("  Outputs: o_busy=%b, o_codword=%h, o_stb=%b",
                         o_busy, o_codword, o_stb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_busy=%b, o_codword=%h, o_stb=%b",
                         expected_o_busy, expected_o_codword, expected_o_stb);
                $display("  Got:      o_busy=%b, o_codword=%h, o_stb=%b",
                         o_busy, o_codword, o_stb);
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
        $dumpvars(0,i_busy, i_clk, i_codword, i_cyc, i_int, i_stb, i_tx_busy, o_busy, o_codword, o_stb);
    end

endmodule
