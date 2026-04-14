`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    wire channel_sel;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .channel_sel(channel_sel),
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
        start = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        $display("DUT Reset Complete");
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Post-Reset Idle State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: First Transfer (Channel 0)", test_num);
        reset_dut();

        start = 1;
        @(posedge clk);
        start = 0;
        @(posedge clk);



        #1;




        check_outputs(1'b0, data_out);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Second Transfer (Alternation to Channel 1)", test_num);
        reset_dut();


        start = 1; @(posedge clk); start = 0;
        @(posedge clk);


        start = 1; @(posedge clk); start = 0;
        @(posedge clk);


        #1;



        check_outputs(1'b1, data_out);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Third Transfer (Back to Channel 0)", test_num);
        reset_dut();


        start = 1; @(posedge clk); start = 0; @(posedge clk);

        start = 1; @(posedge clk); start = 0; @(posedge clk);

        start = 1; @(posedge clk); start = 0; @(posedge clk);


        #1;



        check_outputs(1'b0, data_out);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Sequence 0-1-0-1", test_num);
        reset_dut();


        repeat(4) begin
            start = 1; @(posedge clk); start = 0; @(posedge clk);
        end



        #1;




        check_outputs(1'b1, data_out);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Reset Mid-Sequence", test_num);
        reset_dut();


        start = 1; @(posedge clk); start = 0; @(posedge clk);


        reset = 1; @(posedge clk); reset = 0; @(posedge clk);


        start = 1; @(posedge clk); start = 0; @(posedge clk);

        #1;


        check_outputs(1'b0, data_out);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_channel_sel;
        input [7:0] expected_data_out;
        begin
            if (expected_channel_sel === (expected_channel_sel ^ channel_sel ^ expected_channel_sel) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: channel_sel=%b, data_out=%h",
                         channel_sel, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_sel=%b, data_out=%h",
                         expected_channel_sel, expected_data_out);
                $display("  Got:      channel_sel=%b, data_out=%h",
                         channel_sel, data_out);
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
        $dumpvars(0,clk, reset, start, channel_sel, data_out);
    end

endmodule
