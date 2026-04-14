`timescale 1ns/1ps

module wbudecompress_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_stb;
    reg [35:0] i_word;
    wire o_stb;
    wire [35:0] o_word;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbudecompress dut (
        .i_clk(i_clk),
        .i_stb(i_stb),
        .i_word(i_word),
        .o_stb(o_stb),
        .o_word(o_word)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_stb = 0;
            i_word = 36'h0;
            repeat (2) @(posedge i_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Literal Data Pass-through", test_num);
            reset_dut();

            @(posedge i_clk);
            i_stb = 1;
            i_word = 36'h0_123456789;

            @(posedge i_clk);
            i_stb = 0;


            wait(o_stb);
            #1;

            check_outputs(1'b1, 36'h0_123456789);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Second Literal Word", test_num);
            reset_dut();

            @(posedge i_clk);
            i_stb = 1;
            i_word = 36'h0_ABCDEFF00;

            @(posedge i_clk);
            i_stb = 0;

            wait(o_stb);
            #1;

            check_outputs(1'b1, 36'h0_ABCDEFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Decompress Table Index 0", test_num);
            reset_dut();


            @(posedge i_clk);
            i_stb = 1;
            i_word = 36'h0_555555555;
            @(posedge i_clk);



            i_word = 36'h8_00000000;
            @(posedge i_clk);
            i_stb = 0;


            wait(o_stb);
            @(posedge i_clk);


            wait(o_stb);
            #1;

            check_outputs(1'b1, 36'h0_555555555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Continuous Streaming", test_num);
            reset_dut();

            @(posedge i_clk);
            i_stb = 1;
            i_word = 36'h0_AAAAAAAAA;
            @(posedge i_clk);
            i_word = 36'h0_BBBBBBBBB;
            @(posedge i_clk);
            i_stb = 0;

            wait(o_stb);
            @(posedge i_clk);
            wait(o_stb);
            #1;

            check_outputs(1'b1, 36'h0_BBBBBBBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Strobe Inactive Behavior", test_num);
            reset_dut();

            @(posedge i_clk);
            i_stb = 0;
            i_word = 36'h0_FFFFFFFFF;

            repeat (5) @(posedge i_clk);

            if (o_stb === 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Output stayed idle.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Output signaled strobe without input strobe.");
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wbudecompress Testbench");
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
        input expected_o_stb;
        input [35:0] expected_o_word;
        begin
            if (expected_o_stb === (expected_o_stb ^ o_stb ^ expected_o_stb) &&
                expected_o_word === (expected_o_word ^ o_word ^ expected_o_word)) begin
                $display("PASS");
                $display("  Outputs: o_stb=%b, o_word=%h",
                         o_stb, o_word);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_stb=%b, o_word=%h",
                         expected_o_stb, expected_o_word);
                $display("  Got:      o_stb=%b, o_word=%h",
                         o_stb, o_word);
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
        $dumpvars(0,i_clk, i_stb, i_word, o_stb, o_word);
    end

endmodule
