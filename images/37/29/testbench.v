`timescale 1ns/1ps

module pipeline_7_stage_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg rst;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_7_stage dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        data_in = 4'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single Value Propagation (0xA)", test_num);
        reset_dut();

        data_in = 4'hA;
        @(posedge clk);
        data_in = 4'h0;

        repeat (6) @(posedge clk);

        #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum Value Propagation (0xF)", test_num);
        reset_dut();

        data_in = 4'hF;
        @(posedge clk);
        data_in = 4'h0;

        repeat (6) @(posedge clk);

        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Continuous Data Stream", test_num);
        reset_dut();

        data_in = 4'h1; @(posedge clk);
        data_in = 4'h2; @(posedge clk);
        data_in = 4'h3; @(posedge clk);
        data_in = 4'h4; @(posedge clk);
        data_in = 4'h5; @(posedge clk);
        data_in = 4'h6; @(posedge clk);
        data_in = 4'h7; @(posedge clk);

        #1;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bit Patterns (0x5)", test_num);
        reset_dut();

        data_in = 4'h5;
        @(posedge clk);
        data_in = 4'hA;

        repeat (6) @(posedge clk);

        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero Propagation", test_num);
        reset_dut();

        data_in = 4'h0;
        repeat (7) @(posedge clk);

        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Latency Timing Check", test_num);
        reset_dut();

        data_in = 4'hD;
        @(posedge clk);
        data_in = 4'h0;

        repeat (5) @(posedge clk);


        #1;
        if (data_out !== 4'hD) begin
            $display("PASS: Data not leaked early.");

            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hD);
        end else begin
            $display("FAIL: Data appeared too early (Latency error)");
            fail_count = fail_count + 1;
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
        $display("pipeline_7_stage Testbench");
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst, data_out);
    end

endmodule
